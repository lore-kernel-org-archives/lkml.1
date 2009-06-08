Return-Path: <linux-kernel-owner+w=401wt.eu-S1753188AbZFHSKY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188AbZFHSKY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 14:10:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750727AbZFHSKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 14:10:14 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:33996 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272AbZFHSKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 14:10:13 -0400
Date: Tue, 9 Jun 2009 02:01:25 +0800
From: Harald Welte <HaraldWelte@viatech.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: "Michael S. Zick" <lkml@morethan.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Duane Griffin <duaneg@dghda.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>
Subject: Re: [PATCH 1/2] CPUFREQ: Enable acpi-cpufreq driver for
	VIA/Centaur CPUs
Message-ID: <20090608180125.GB4455@prithivi.gnumonks.org>
References: <alpine.LFD.2.01.0906022055030.4880@localhost.localdomain> <20090606132847.GB14088@prithivi.gnumonks.org> <200906060846.36303.lkml@morethan.org> <200906060856.15016.lkml@morethan.org> <20090608102754.GP4106@prithivi.gnumonks.org> <20090608131620.GB15100@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090608131620.GB15100@srcf.ucam.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 08, 2009 at 02:16:20PM +0100, Matthew Garrett wrote:
> On Mon, Jun 08, 2009 at 06:27:54PM +0800, Harald Welte wrote:
> > The VIA/Centaur C7, C7-M and Nano CPU's all support ACPI based cpu p-states
> > using a MSR interface.  The Linux driver just never made use of it, since in
> > addition to the check for the EST flag it also checked if the vendor is Intel.
> 
> Hm. Is the MSR interface compatible with the Intel one? 

Yes, it is intended to be.  If you know of any public intel spec on the actual
MSR values, I'd be happy to have a look and compare it with Centaur's specs.

VIA/Centaur specs are being prepared for public release, but it will probably
take longer than we can responsibly delay fixing this bug.

> I'm guessing so based on the est flag being present. Maybe we should just
> drop the intel check and only look for CPUs which claim est support.

I think that might be the right decision.

-- 
- Harald Welte <HaraldWelte@viatech.com>	    http://linux.via.com.tw/
============================================================================
VIA Free and Open Source Software Liaison
