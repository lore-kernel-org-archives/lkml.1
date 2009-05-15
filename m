Return-Path: <linux-kernel-owner+w=401wt.eu-S1756048AbZEOTMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048AbZEOTMd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 15:12:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752785AbZEOTMW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 15:12:22 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:51651 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751349AbZEOTMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 15:12:21 -0400
Date: Fri, 15 May 2009 12:12:21 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Renninger <trenn@suse.de>,
       linux-kernel <linux-kernel@vger.kernel.org>, cpufreq@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH v2] acpi: Fix regression where _PPC is not read at boot
	even when ignore_ppc=0
Message-ID: <20090515191219.GH6968@plum>
Reply-To: djwong@us.ibm.com
References: <20090416174217.GY8311@plum> <20090416224507.GA31984@srcf.ucam.org> <20090428193303.GC6968@plum> <20090428195348.GA8376@srcf.ucam.org> <20090429213930.GE6968@plum> <20090429220037.GA8604@srcf.ucam.org> <20090430072556.GD16737@elte.hu> <20090430095414.GA19462@srcf.ucam.org> <20090430111042.GA12809@elte.hu> <20090430111338.GA21297@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090430111338.GA21297@srcf.ucam.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 30, 2009 at 12:13:38PM +0100, Matthew Garrett wrote:
> On Thu, Apr 30, 2009 at 01:10:42PM +0200, Ingo Molnar wrote:
> 
> > thanks - i've applied this and started testing it. I suspect 1-2 
> > days of test-time should be enough to see if it breaks this box in 
> > any way.
> 
> My recollection was that you'd see the machine limited to 1GHz on every 
> boot?

That seems accurate based on my reading of the old thread.

It's been a couple of weeks; has anyone seen any problems?

--D
