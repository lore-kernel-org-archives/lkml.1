Return-Path: <linux-kernel-owner+w=401wt.eu-S934157AbXEGOkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934157AbXEGOkj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 10:40:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934086AbXEGOkg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 10:40:36 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:58912
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933974AbXEGOkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 10:40:35 -0400
Date: Mon, 7 May 2007 07:37:57 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Oliver Neukum <oneukum@suse.de>
cc: Pavel Machek <pavel@ucw.cz>, David Lang <david.lang@digitalinsight.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka J Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Back to the future.
In-Reply-To: <200705071452.21969.oneukum@suse.de>
Message-ID: <Pine.LNX.4.64.0705070736010.18013@asgard.lang.hm>
References: <1177567481.5025.211.camel@nigel.suspend2.net>
 <Pine.LNX.4.63.0705061909290.19118@qynat.qvtvafvgr.pbz> <20070507124818.GA18209@elf.ucw.cz>
 <200705071452.21969.oneukum@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 May 2007, Oliver Neukum wrote:

> Am Montag, 7. Mai 2007 14:48 schrieb Pavel Machek:
>>>> Including network? Your tcp peers will be really confused, then, if
>>>> you ACK packets then claim you did not get them. No, you do not want
>>>> to start network.
>>>
>>> anyone who is doing a hibernate or suspend who expect all the network
>>> connections to be working afterwords is dreaming or smokeing
>>> something.
>>
>> Really? It works today... if the suspend is short enough. And that's
>> how it should be.
>
> If we get very good at Wake-on-Lan it should work for any length
> of time.

for suspend-to-ram this would work, I stand corrected.

for hibernate this would almost certinly not work, and I don't think that 
it's worth raising false hopes.

David Lang
