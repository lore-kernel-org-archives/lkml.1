Return-Path: <linux-kernel-owner+w=401wt.eu-S1765343AbYEFQYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765343AbYEFQYY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 12:24:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759227AbYEFQXh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 12:23:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47806 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752975AbYEFQXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 12:23:34 -0400
Date: Tue, 6 May 2008 09:23:26 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata updates
In-Reply-To: <20080506154847.GA15299@havoc.gtf.org>
Message-ID: <alpine.LFD.1.10.0805060919410.32269@woody.linux-foundation.org>
References: <20080506154847.GA15299@havoc.gtf.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 6 May 2008, Jeff Garzik wrote:
>  
> +config PATA_SCH
> +	tristate "Intel SCH PATA support"
> +	depends on PCI
> +	help
> +	  This option enables support for Intel SCH PATA on the Intel
> +	  SCH (US15W, US15L, UL11L) series host controllers.
> +
> +	  If unsure, say N.

I think it would generally be good if people explained their drivers 
better than this.

If you know what the hell an SCH is, you don't *need* that help message in 
the first place! Agreed?

IOW, when adding drivers, please add help messages that actually explain 
what the driver is from a *user* perspective, not from a chip designer 
perspective. In this case, something like

	The Intel SCH chipset is the new low-power, small-footprint 
	embedded chipset that is generally paired with the Atom CPU and is 
	not their normal PC chipset.

or something. So that people can actually make a somewhat informed guess 
about whether it's relevant to them or not.

		Linus
