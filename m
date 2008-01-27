Return-Path: <linux-kernel-owner+w=401wt.eu-S1757268AbYA0PNP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757268AbYA0PNP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 10:13:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753494AbYA0PM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 10:12:59 -0500
Received: from ananke.telenet-ops.be ([195.130.137.78]:36908 "EHLO
	ananke.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267AbYA0PM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 10:12:58 -0500
Date: Sun, 27 Jan 2008 16:12:52 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Michal Simek <monstr@monstr.eu>
cc: linux-kernel@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       john.williams@petalogix.com, microblaze-uclinux@itee.uq.edu.au
Subject: Re: [PATCH 17/52] [microblaze] checksum support
In-Reply-To: <479C8A0E.40804@monstr.eu>
Message-ID: <Pine.LNX.4.64.0801271611470.6736@anakin>
References: <1201187014-3979-1-git-send-email-monstr@monstr.eu>
 <dbff6b883dbcb108db53e5093994c473946e1240.1201107832.git.monstr@monstr.eu>
 <ac0947adfe718fcb4c0dc5f6f7ab64f8155541fb.1201107832.git.monstr@monstr.eu>
 <873c2bf1f67696aa11014886470f6ba46f04e8d2.1201107832.git.monstr@monstr.eu>
 <516d173b1789ea533431e8f5ad05751c6a353c88.1201107832.git.monstr@monstr.eu>
 <068508828aac6298b4cc65b0cd7b2737a61c466c.1201107832.git.monstr@monstr.eu>
 <010fc233f82a8f7a591c9f8315ae03f9951139aa.1201107832.git.monstr@monstr.eu>
 <68faaf69ea03196d4a56a263707355e7e7eb5c6a.1201107832.git.monstr@monstr.eu>
 <4b7d90fc1b9bcb3c0b1b308c6460390f7bdf3824.1201107832.git.monstr@monstr.eu>
 <Pine.LNX.4.64.0801271256300.6736@anakin> <479C8A0E.40804@monstr.eu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Jan 2008, Michal Simek wrote:
> > So basically this is a copy of arch/m68knommu/lib/checksum.c, with some
> > checkpatch.pl fixes but without the sparse fixes?
> > Furthermore, it's just plain C, so maybe we need a common one that can
> > be shared by multiple archs?
> > 
>   
> I have no sparse errors and warning in checksum.c file.

How come csum_partial_copy_from_user() in arch/m68knommu/lib/checksum.c
has a __user attribute on the src parameter, while yours doesn't?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
