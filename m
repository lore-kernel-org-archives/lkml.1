Return-Path: <linux-kernel-owner+w=401wt.eu-S1756523AbZJLNgZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756523AbZJLNgZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 09:36:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755993AbZJLNgY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 09:36:24 -0400
Received: from fanny.its.uu.se ([130.238.4.241]:37160 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754144AbZJLNgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 09:36:23 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19155.12454.655519.908173@pilspetsen.it.uu.se>
Date: Mon, 12 Oct 2009 15:35:34 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "David Woodhouse" <David.Woodhouse@intel.com>,
       "David Woodhouse" <dwmw2@infradead.org>,
       "Greg Kroah-Hartman" <gregkh@suse.de>,
       "Mikael Pettersson" <mikpe@it.uu.se>, "Nick Piggin" <npiggin@suse.de>
Subject: Re: [Bug #14374] MCEs caused by commit db8be50c4307dac2b37305fc59c8dc0f978d09ea
In-Reply-To: <r-4Wjt4coy.A.DGD.aal0KB@chimera>
References: <zJ_pXHNwoHC.A.akB.Aal0KB@chimera>
	<r-4Wjt4coy.A.DGD.aal0KB@chimera>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> The following bug entry is on the current list of known regressions
> from 2.6.31.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D14374
> Subject		: MCEs caused by commit db8be50c4307dac2b37305fc59c8dc0f978d09ea
> Submitter	: Nick Piggin <npiggin@suse.de>
> Date		: 2009-10-02 7:34 (10 days old)
> First-Bad-Commit: http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linu=
> x-2.6.git;a=3Dcommit;h=3Ddb8be50c4307dac2b37305fc59c8dc0f978d09ea
> References	: http://marc.info/?l=3Dlinux-kernel&m=3D125446885705223&w=3D4

Fixed for 2.6.32-rc5 by d93a8f829fe1d2f3002f2c6ddb553d12db420412
'Revert "USB: Work around BIOS bugs by quiescing USB controllers earlier"'.
