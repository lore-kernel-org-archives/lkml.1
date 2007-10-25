Return-Path: <linux-kernel-owner+w=401wt.eu-S1758128AbXJYLS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758128AbXJYLS1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 07:18:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754175AbXJYLSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 07:18:17 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35824 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753662AbXJYLSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 07:18:16 -0400
Date: Thu, 25 Oct 2007 12:17:36 +0100
From: Christoph Hellwig <hch@infradead.org>
To: "Villacis, Juan" <juan.villacis@intel.com>
Cc: Jeff Garzik <jeff@garzik.org>, eranian@hpl.hp.com,
       "Luck, Tony" <tony.luck@intel.com>, linux-ia64@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Stone, Joshua I" <joshua.i.stone@intel.com>
Subject: Re: [PATCH] IA64/perfmon: kill dead code, clean irq handling
Message-ID: <20071025111736.GA1414@infradead.org>
References: <20071023230908.GA12417@havoc.gtf.org> <20071025084615.GA32656@frankl.hpl.hp.com> <4720592D.4030604@garzik.org> <176273AE807A344A8C14F517A8FC59C20259A09E@scsmsx412.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <176273AE807A344A8C14F517A8FC59C20259A09E@scsmsx412.amr.corp.intel.com>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2007 at 04:05:18AM -0700, Villacis, Juan wrote:
> Hi,
> 
> The VTune sampling driver currently uses this hook for cases where it
> needs to do its own handling of the PMU on platforms that Perfmon2 may
> not yet (fully, correctly) recognize at the time of the kernel's
> release.

So killing it might be a good way to make the vtune folks more cooperative.
Remember we don't keep hooks for crappy out of tree code around.
