Return-Path: <linux-kernel-owner+w=401wt.eu-S1755776AbZD3LOA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755776AbZD3LOA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 07:14:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753988AbZD3LNs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 07:13:48 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:60654 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115AbZD3LNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 07:13:47 -0400
Date: Thu, 30 Apr 2009 12:13:38 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Darrick J. Wong" <djwong@us.ibm.com>, Thomas Renninger <trenn@suse.de>,
       linux-kernel <linux-kernel@vger.kernel.org>, cpufreq@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH v2] acpi: Fix regression where _PPC is not read at boot
	even when ignore_ppc=0
Message-ID: <20090430111338.GA21297@srcf.ucam.org>
References: <200904161201.13409.trenn@suse.de> <20090416174217.GY8311@plum> <20090416224507.GA31984@srcf.ucam.org> <20090428193303.GC6968@plum> <20090428195348.GA8376@srcf.ucam.org> <20090429213930.GE6968@plum> <20090429220037.GA8604@srcf.ucam.org> <20090430072556.GD16737@elte.hu> <20090430095414.GA19462@srcf.ucam.org> <20090430111042.GA12809@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090430111042.GA12809@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 30, 2009 at 01:10:42PM +0200, Ingo Molnar wrote:

> thanks - i've applied this and started testing it. I suspect 1-2 
> days of test-time should be enough to see if it breaks this box in 
> any way.

My recollection was that you'd see the machine limited to 1GHz on every 
boot?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
