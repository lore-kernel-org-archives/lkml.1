Return-Path: <linux-kernel-owner+w=401wt.eu-S1753708AbXEGCww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708AbXEGCww (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 22:52:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753729AbXEGCww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 22:52:52 -0400
Received: from warden-p.diginsite.com ([208.29.163.248]:53938 "HELO
	warden.diginsite.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1753699AbXEGCwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 22:52:51 -0400
Date: Sun, 6 May 2007 19:13:51 -0700 (PDT)
From: David Lang <david.lang@digitalinsight.com>
X-X-Sender: dlang@dlang.diginsite.com
To: Pavel Machek <pavel@ucw.cz>
cc: Nigel Cunningham <nigel@nigel.suspend2.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka J Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Back to the future.
In-Reply-To: <20070503171843.GA4355@ucw.cz>
Message-ID: <Pine.LNX.4.63.0705061909290.19118@qynat.qvtvafvgr.pbz>
References: <1177567481.5025.211.camel@nigel.suspend2.net> 
 <200704280041.17617.rjw@sisk.pl>  <alpine.LFD.0.98.0704271612380.9964@woody.linux-foundation.org>
  <200704280145.26253.rjw@sisk.pl>  <1177718250.4737.222.camel@nigel.suspend2.net>
  <Pine.LNX.4.63.0704271638150.11000@qynat.qvtvafvgr.pbz> <20070503171843.GA4355@ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 May 2007, Pavel Machek wrote:

> Hi!
>
>> nobody is suggesting that you leave peocesses running
>> while you do the snapshot, what is being proposed is
>>
>> 1. pause userspace (prevent scheduling)
>> 2. make snapshot image of memory
>> 3. make mounted filesystems read-only (possibly with
>> snapshot/checkpoint)
>> 4. unpause
>> 5. save image (with full userspace available, including
>> network)
>
> Including network? Your tcp peers will be really confused, then, if
> you ACK packets then claim you did not get them. No, you do not want
> to start network.

anyone who is doing a hibernate or suspend who expect all the network 
connections to be working afterwords is dreaming or smokeing something.

this is just another way that the failure can show up.

in fact, I would say that it would probalby be a nice thing to do for 
intervening firewalls and external servers if a suspend closed all external TCP 
connections rather then leaving them dangling (eating up resources until they 
time out)

if you software can't tolorate the network connection going away on you it will 
have problems in normal operation anyway, let alone when you suspend/hibernate 
your machine.

David Lang
