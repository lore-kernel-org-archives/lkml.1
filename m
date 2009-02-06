Return-Path: <linux-kernel-owner+w=401wt.eu-S1756664AbZBFS4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756664AbZBFS4g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 13:56:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752730AbZBFS4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 13:56:21 -0500
Received: from aun.it.uu.se ([130.238.12.36]:38052 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751953AbZBFS4U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 13:56:20 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18828.34746.639582.20441@harpo.it.uu.se>
Date: Fri, 6 Feb 2009 19:55:54 +0100
From: Mikael Pettersson <mikpe@it.uu.se>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Mikael Pettersson <mikpe@it.uu.se>
Subject: Re: [Bug #12508] "powerpc/pci: Reserve legacy regions on PCI"
 broke my G3
In-Reply-To: <1233783867.4612.9.camel@pasglop>
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera>
	<pWZw1SZjMCH.A.ZIG.YvYiJB@chimera>
	<1233783867.4612.9.camel@pasglop>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt writes:
 > On Wed, 2009-02-04 at 11:24 +0100, Rafael J. Wysocki wrote:
 > > This message has been generated automatically as a part of a report
 > > of recent regressions.
 > > 
 > > The following bug entry is on the current list of known regressions
 > > from 2.6.28.  Please verify if it still should be listed and let me know
 > > (either way).
 > 
 > Can you check if it's still broken ?
 > 
 > 59b608c2c33feacc8be281ec3ba9ca2a3a5cb9a7 might have fixed it...
 > 
 > Cheers,
 > Ben.

Confirmed. Adding 59b608c2c33feacc8be281ec3ba9ca2a3a5cb9a7 to
2.6.29-rc3 makes it boot fine on my G3.

Thanks,

/Mikael

 > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12508
 > > Subject		: "powerpc/pci: Reserve legacy regions on PCI" broke my G3
 > > Submitter	: Mikael Pettersson <mikpe@it.uu.se>
 > > Date		: 2009-01-17 22:46 (19 days old)
 > > First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=c1f343028d35ba4e88cd4a3c44e0d8b8a84264ee
 > > References	: http://marc.info/?l=linux-kernel&m=123223247325452&w=4
 > > Handled-By	: Benjamin Herrenschmidt <benh@kernel.crashing.org>
