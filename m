Return-Path: <linux-kernel-owner+w=401wt.eu-S1754266AbZKUMhc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266AbZKUMhc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 07:37:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754009AbZKUMhb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 07:37:31 -0500
Received: from fanny.its.uu.se ([130.238.4.241]:60124 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753751AbZKUMha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 07:37:30 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19207.57093.690723.147782@pilspetsen.it.uu.se>
Date: Sat, 21 Nov 2009 13:37:25 +0100
From: Mikael Pettersson <mikpe@it.uu.se>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Mikael Pettersson" <mikpe@it.uu.se>
Subject: Re: [Bug #14256] kernel BUG at fs/ext3/super.c:435
In-Reply-To: <OWmO9uyC1hM.A.HyC.IodALB@chimera>
References: <ipicVA1QUFF.A.zWB.1mdALB@chimera>
	<OWmO9uyC1hM.A.HyC.IodALB@chimera>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> The following bug entry is on the current list of known regressions
> introduced between 2.6.30 and 2.6.31.  Please verify if it still should
> be listed and let me know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D14256
> Subject		: kernel BUG at fs/ext3/super.c:435
> Submitter	: Mikael Pettersson <mikpe@it.uu.se>
> Date		: 2009-09-21 7:29 (57 days old)
> References	: http://marc.info/?l=3Dlinux-kernel&m=3D125351816109264&w=3D4

Still occurs with kernel 2.6.32-rc8.

This time I only rebuilt the glibc src rpm, which also runs its
test suite, but I did not install the new glibc binaries before
the shutdown -r.
