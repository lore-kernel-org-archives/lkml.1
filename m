Return-Path: <linux-kernel-owner+w=401wt.eu-S933263AbXGLBOj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933263AbXGLBOj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 21:14:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758887AbXGLBO3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 21:14:29 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:24579 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758637AbXGLBO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 21:14:28 -0400
Subject: Re: Forward port of latest RT patch (2.6.21.5-rt20) to 2.6.22
	available
From: Daniel Walker <dwalker@mvista.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: mingo@elte.hu, tglx@linutronix.de, jim.houston@ccur.com,
       joe.korty@ccur.com, David Bahi <DBahi@novell.com>,
       Moiz Kohari <MKohari@novell.com>, Sven Dietrich <SDietrich@novell.com>,
       dsaxena@plexity.net, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
In-Reply-To: <469544710200005A000275CC@mcclure.wal.novell.com>
References: <469544710200005A000275CC@mcclure.wal.novell.com>
Content-Type: text/plain
Date: Wed, 11 Jul 2007 18:05:36 -0700
Message-Id: <1184202337.7974.20.camel@dhcp193.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-07-11 at 20:58 -0400, Gregory Haskins wrote:
> Hi Ingo, Thomas, and the greater linux-rt community,
>   
> 	I just wanted to let you guys know that our team has a port of the
> 21.5-rt20 patch for the 2.6.22 kernel available.  It in no way should be
> construed as a substitute for the forthcoming official release from the
> RT community.  We are submitting it now in hopes it will be useful to
> someone in the interim, even if only for reference for the official
> porting effort (since we have resolved numerous issues that were
> introduced in the new vanilla code since 21 already).  We hope to rebase
> to Ingo's offical patch once it is available.
> 
> 	As a caveat, I'm sure there are numerous errors which were introduced
> by a combination of unnoticed patch fuzz, human error, etc.  But we do
> have it building and running pretty reliably on a number of 2-way,
> 4-way, and 8-way x86_64 SMP systems here in our lab with various
> configurations.  It yields very impressive cyclic-test results with our
> reference PREEMPT_RT config (see attached) so we know that generally the
> port went ok.
> 
> 	There is some fallout that occurred related to some slob changes
> between rc1-rc2 that we could probably use some feedback on.  I have
> attached a file (problem-patches.txt) that lists the names/commit-ids of
> some of the patches that we know to be problematic from bisecting.
> There is also a cheesy hack in fs/buffer.c that is probably just plain
> wrong, but we are still trying to find a good way to fix an issue with
> the IDE driver.  
> 
> 	Note also that we find that the resulting kernel does not boot on some
> T60p thinkpads without "acpi=off".  We are still investigating the root
> cause here.
> 
> You can find the patch available here:
> ftp://ftp.novell.com/dev/patch-2.6.22-rt1

Thanks for the effort!

Couple of comments tho .. You might want to change the name of the patch
to distinguish it from Ingo's patch ..

Also it would be nice to move away from the "One Big Patch" release
method , for instance if you could break it up into two or more patches
one with the stuff from the patch-2.6.21.5-rt20 which applied, and
another patch with the reject resolution. That way we can see what was
added ..

Daniel

