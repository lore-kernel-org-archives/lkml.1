Return-Path: <linux-kernel-owner+w=401wt.eu-S1757469AbXGIPwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757469AbXGIPwX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 11:52:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753724AbXGIPwQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 11:52:16 -0400
Received: from cavan.codon.org.uk ([217.147.92.49]:52406 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710AbXGIPwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 11:52:15 -0400
Date: Mon, 9 Jul 2007 16:51:51 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Adrian Bunk <bunk@stusta.de>
Cc: Zhang Rui <rui.zhang@intel.com>, lenb@kernel.org,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20070709155151.GA27711@srcf.ucam.org>
References: <20070709145755.GD3492@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070709145755.GD3492@stusta.de>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [2.6 patch] the scheduled ACPI_PROCFS removal
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 09, 2007 at 04:57:56PM +0200, Adrian Bunk wrote:
> This patch contains the scheduled removal of the ACPI procfs interface.

This was only flagged deprecated in January. Userspace hasn't really 
caught up, so I think removing it now is premature. Given the quantity 
of software that's been written to use the old /proc interface, I don't 
think we're realistically going to be able to remove it in the 
forseeable future.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
