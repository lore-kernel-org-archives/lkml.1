Return-Path: <linux-kernel-owner+w=401wt.eu-S1753274AbXCMPiG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274AbXCMPiG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 11:38:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753284AbXCMPiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 11:38:05 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:44776 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274AbXCMPiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 11:38:04 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17910.50411.80974.295620@smtp.charter.net>
Date: Tue, 13 Mar 2007 11:36:11 -0400
From: "John Stoffel" <john@stoffel.org>
To: Serge Belyshev <belyshev@depni.sinp.msu.ru>
Cc: Mike Galbraith <efault@gmx.de>, Con Kolivas <kernel@kolivas.org>,
       Ingo Molnar <mingo@elte.hu>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH][RSDL-mm 0/7] RSDL cpu scheduler for 2.6.21-rc3-mm2
In-Reply-To: <87bqix5q18.fsf@depni.sinp.msu.ru>
References: <200703111457.17624.kernel@kolivas.org>
	<1173778398.6810.21.camel@Homer.simpson.net>
	<20070313093914.GA10533@elte.hu>
	<200703132106.08878.kernel@kolivas.org>
	<1173785006.8561.19.camel@Homer.simpson.net>
	<87bqix5q18.fsf@depni.sinp.msu.ru>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Serge" == Serge Belyshev <belyshev@depni.sinp.msu.ru> writes:

Serge> Mike Galbraith <efault@gmx.de> writes:
Serge> [snip]
>> It seems to be a plain linear slowdown.  The lurchiness I'm experiencing
>> varies in intensity, and is impossible to quantify.  I see neither
>> lurchiness nor slowdown in mainline through -j8.
>> 

Serge> Whaa? make -j8 on mainline makes my desktop box completely
Serge> useless.

I tried a make -j5 on my Dual processor PIII Xeon box.  It was pretty
slow.  Firefox was ok scrolling with keyboard, but the scrollbar was
jerky.  I also has MP3s playing at the same time and it worked just
fine.  No drops that I heard. 

This is 2.6.21-rc3 patched with RSDL.  

To me, that large a load on my system was just pushing it too hard.
Esp since firefox seems to have become a total CPU hog in it's own
right lately.  Or is that because I have a Matrox G450 as my video
card and it's not handling GPU rendering in the card, but in the OS
these days?  I dunno...

I guess I need to reboot into the default scheduler and see how it
goes.  

Serge> Please reconsider your statement.

This is not a nice statement on your half.  Mike has been doing a
great job testing.  He and Con don't seem to communicate well at
times, but hey, they're still talking and working together, even with
friction.  I'm happy to see all this testing going on!

