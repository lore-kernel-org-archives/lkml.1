Return-Path: <linux-kernel-owner+w=401wt.eu-S1755047AbZFHNQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755047AbZFHNQc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 09:16:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753569AbZFHNQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 09:16:24 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:50208 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833AbZFHNQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 09:16:24 -0400
Date: Mon, 8 Jun 2009 14:16:20 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Harald Welte <HaraldWelte@viatech.com>
Cc: "Michael S. Zick" <lkml@morethan.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Duane Griffin <duaneg@dghda.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>
Subject: Re: [PATCH 1/2] CPUFREQ: Enable acpi-cpufreq driver for
	VIA/Centaur CPUs
Message-ID: <20090608131620.GB15100@srcf.ucam.org>
References: <alpine.LFD.2.01.0906022055030.4880@localhost.localdomain> <20090606132847.GB14088@prithivi.gnumonks.org> <200906060846.36303.lkml@morethan.org> <200906060856.15016.lkml@morethan.org> <20090608102754.GP4106@prithivi.gnumonks.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090608102754.GP4106@prithivi.gnumonks.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 08, 2009 at 06:27:54PM +0800, Harald Welte wrote:
> The VIA/Centaur C7, C7-M and Nano CPU's all support ACPI based cpu p-states
> using a MSR interface.  The Linux driver just never made use of it, since in
> addition to the check for the EST flag it also checked if the vendor is Intel.

Hm. Is the MSR interface compatible with the Intel one? I'm guessing so 
based on the est flag being present. Maybe we should just drop the intel 
check and only look for CPUs which claim est support.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
