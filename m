Return-Path: <linux-kernel-owner+w=401wt.eu-S1756741AbXIWOG4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741AbXIWOG4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 10:06:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753859AbXIWOGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 10:06:49 -0400
Received: from cavan.codon.org.uk ([78.32.9.130]:59410 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753819AbXIWOGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 10:06:48 -0400
Date: Sun, 23 Sep 2007 15:06:16 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oleg Verych <olecom@flower.upol.cz>, Thomas Gleixner <tglx@linutronix.de>,
       mihai.dontu@gmail.com, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Len Brown <lenb@kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Message-ID: <20070923140615.GA10006@srcf.ucam.org>
References: <20070922220347.586903979@linutronix.de> <alpine.LFD.0.999.0709221546250.16478@woody.linux-foundation.org> <E1IZG8l-0002jB-2k@flower> <alpine.LFD.0.999.0709222008580.16478@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0709222008580.16478@woody.linux-foundation.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [patch 0/2] suspend/resume regression fixes
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 22, 2007 at 08:11:06PM -0700, Linus Torvalds wrote:

> From a "future behaviour" standpoint it would probably be interesting to 
> hear whether Mihai can make his machine with not with the old IDE layer 
> (which distributions are migrating away from) but with the ATA layer 
> (libata) instead. It too should hopefully know about using ACPI to restore 
> any ATA controller quirks.

It does, but it's disabled by default. libata needs to be loaded with 
noacpi=0.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
