Return-Path: <linux-kernel-owner+w=401wt.eu-S1755332AbZFHMJQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332AbZFHMJQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 08:09:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754762AbZFHMJB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 08:09:01 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:52060 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754629AbZFHMJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 08:09:01 -0400
Date: Mon, 8 Jun 2009 13:08:46 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Harald Welte <HaraldWelte@viatech.com>
Cc: "Michael S. Zick" <lkml@morethan.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Duane Griffin <duaneg@dghda.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>
Subject: Re: [PATCH 2/2] CPUFREQ: Mark e_powersaver driver as EXPERIMENTAL
	and DANGEROUS
Message-ID: <20090608120846.GA13328@srcf.ucam.org>
References: <20090608102936.GQ4106@prithivi.gnumonks.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090608102936.GQ4106@prithivi.gnumonks.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 08, 2009 at 06:29:36PM +0800, Harald Welte wrote:
> The e_powersaver driver for VIA's C7 CPU's needs to be marked as
> DANGEROUS as it configures the CPU to power states that are out
> of specification.
> 
> According to Centaur, all systems with C7 and Nano CPU's support
> the ACPI p-state method.  Thus, the acpi-cpufreq driver should
> be used instead.

Do we know if vendors are actually shipping with the appropriate BIOS 
tables? The number of people using e_powersaver seems to be suspiciously 
large, though perhaps that's just because the help text implied it was 
the right choice for C7.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
