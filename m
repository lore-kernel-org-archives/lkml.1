Return-Path: <linux-kernel-owner+w=401wt.eu-S1752011AbXLDFIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011AbXLDFIW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 00:08:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750831AbXLDFIP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 00:08:15 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48811 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750798AbXLDFIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 00:08:14 -0500
Date: Mon, 3 Dec 2007 21:08:12 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.24-rc4
Message-ID: <alpine.LFD.0.9999.0712032055080.2981@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We should have one week between -rc releases, but I was gone for a week 
over thanksgiving (as were some other kernel developers), so this one is a 
bit late. It's been almost the rule rather than the exception, but I 
promise I'll be better...

Anyway, there aren't a lot of exciting changes here, but there's still a 
_lot_ more churn than I really hoped for at the -rc4 stage. Blackfin, MIPS 
and Power do stand out in the diffstats, but ARM and x86 got some updates 
too.

And we had some ACPI churn (processor throttling etc), along with various 
driver updates: ATA, IDE, infiniband, SCSI, USB and network drivers.. And 
on the filesystem side, cifs, NFS, ocfs2 and proc. Ugh. Too much.

In fact, the diff from -rc3 is almost 36,000 lines, and that's the smaller 
git one with the renames shown as renames (not the ones I upload as 
patches to kernel.org - those are done so that people with GNU patch and 
other legacy patch programs can use the diffs). I'll blame the two-week 
window for some of it, but even so, this is a bit disheartening. I'm 
really hoping that we're slowing down and -rc5 won't be anywhere near that 
large.

That said, none of the changes are really _exciting_ or really scary. And 
we should have fixed a number of regressions, although more certainly 
remain.

				Linus
