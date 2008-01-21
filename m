Return-Path: <linux-kernel-owner+w=401wt.eu-S1757122AbYAUAoq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757122AbYAUAoq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 19:44:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755839AbYAUAog
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 19:44:36 -0500
Received: from crca.org.au ([67.207.131.56]:58516 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754671AbYAUAof convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 19:44:35 -0500
X-Greylist: delayed 662 seconds by postgrey-1.27 at vger.kernel.org; Sun, 20 Jan 2008 19:44:35 EST
Message-ID: <20080121003332.91yx02wc0sgk0sg4@mail.crca.org.au>
Date: Mon, 21 Jan 2008 00:33:32 +0000
From: nigel@crca.org.au
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.24 regression: reference count leak in PPPoE
References: <200801202053.30386.ak@suse.de>
	<20080120200109.GA31876@elte.hu>
In-Reply-To: <20080120200109.GA31876@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	DelSp=Yes	format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 7BIT
User-Agent: Internet Messaging Program (IMP) H3 (4.1.4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

Quoting Ingo Molnar <mingo@elte.hu>:

>
> * Andi Kleen <ak@suse.de> wrote:
>
>> My workstation running 2.6.24-rc8 just hung during shutdown with an
>> endless (or rather I didn't wait more than a few minutes) loop of
>>
>> unregister_netdev: waiting for ppp-device to become free. Usage count
>> = 1
>>
>> ppp-device was an active PPPoE device.
>>
>> No more information currently.
>
> i've seen such problems (locked up box with endless loop of usage count
> == 1) with pppoe in the past, and it seemed to be related to dynamic
> IPs. (i saw that well before 2.6.24 - reported it once to davem)
>
> It seems to have stopped when i stopped using ipsec and started using
> vpnc. (but no firm info - this was sporadic - happened every few months
> or so) Are you using ipsec and dynamic IPs by any chance?

This isn't PPPoE specific. It has also been seen with e1000, madwifi  
and an intel based card. It was introduced by a Jan 10 commit post rc7  
(sorry, don't have the details right now - my laptop died yesterday).  
A bugzilla has already been opened.

Nigel

----------------------------------------------------------------
This message was sent using IMP, the Internet Messaging Program.

