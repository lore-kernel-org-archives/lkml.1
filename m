Return-Path: <linux-kernel-owner+w=401wt.eu-S2992571AbXCWU5G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992571AbXCWU5G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 16:57:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992572AbXCWU5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 16:57:06 -0400
Received: from cavan.codon.org.uk ([217.147.92.49]:45699 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992571AbXCWU5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 16:57:05 -0400
Date: Fri, 23 Mar 2007 20:56:53 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       kyle@canonical.com
Message-ID: <20070323205652.GA9965@srcf.ucam.org>
References: <20070323191321.5d00887a@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070323191321.5d00887a@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: HPA patches
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 23, 2007 at 07:13:21PM +0000, Alan Cox wrote:
> +static int ata_ignore_hpa = 0;
> +module_param_named(ignore_hpa, ata_ignore_hpa, int, 0644);
> +MODULE_PARM_DESC(ignore_hpa, "Ignore HPA (0=off 1=on)");

I'm not sure I like the language here. "Ignore HPA" appears to mean 
"Explicitly disable the HPA", which I guess is one interpretation of 
"ignore" - however, naively I'd expect "Ignore HPA" to mean "Don't touch 
the HPA" with the result that it would remain inaccessible to userspace.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
