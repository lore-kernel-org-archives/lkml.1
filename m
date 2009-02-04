Return-Path: <linux-kernel-owner+w=401wt.eu-S1753022AbZBDGPX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022AbZBDGPX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 01:15:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750892AbZBDGPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 01:15:09 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:42910 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbZBDGPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 01:15:09 -0500
Date: Wed, 4 Feb 2009 06:15:05 +0000
From: Matthew Garrett <mjg@redhat.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ACPI: make some IO ports off-limits to AML
Message-ID: <20090204061505.GD28321@srcf.ucam.org>
References: <alpine.LFD.2.00.0902032258080.5607@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0902032258080.5607@localhost.localdomain>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 03, 2009 at 10:59:43PM -0500, Len Brown wrote:

> Start using this interface to prevent AML from accessing
> some well known IO addresses that the OS "owns".

It might be nice to extend this to cover the other ports listed at 
http://www.microsoft.com/whdc/archive/BIOSAML.mspx if (and only if) the 
firmware requested _OSI("Windows 2001") or later.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
