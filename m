Return-Path: <linux-kernel-owner+w=401wt.eu-S1754722AbXLHKiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722AbXLHKiS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 05:38:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750949AbXLHKiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 05:38:06 -0500
Received: from cavan.codon.org.uk ([78.32.9.130]:34020 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704AbXLHKiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 05:38:04 -0500
Date: Sat, 8 Dec 2007 10:28:58 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andreas Mohr <andi@lisas.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-ide@vger.kernel.org,
       Tejun Heo <htejun@gmail.com>, Len Brown <lenb@kernel.org>,
       linux-acpi@vger.kernel.org
Message-ID: <20071208102858.GA12080@srcf.ucam.org>
References: <200712080340.49546.rjw@sisk.pl> <20071208013631.3147986a.akpm@linux-foundation.org> <20071208101256.GA25807@rhlx01.hs-esslingen.de> <20071208022001.155e0c52.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071208022001.155e0c52.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: 2.6.24-rc4-git5: Reported regressions from 2.6.23
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 08, 2007 at 02:20:01AM -0800, Andrew Morton wrote:
> On Sat, 8 Dec 2007 11:12:57 +0100 Andreas Mohr <andi@lisas.de> wrote:
> > ACPI Exception (exoparg2-0442): AE_AML_PACKAGE_LIMIT, Index (0FFFFFFFF) is beyond end of object [20070126]
> > ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.IDE0.GTF_] (Node c180b990), AE_AML_PACKAGE_LIMIT
> > ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.IDE0.CHN0.DRV1._GTF] (Node c180b888), AE_AML_PACKAGE_LIMIT
> > ata1.01: _GTF evaluation failed (AE 0x300d)

037f6bb79f753c014bc84bca0de9bf98bb5ab169 ought to have fixed this?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
