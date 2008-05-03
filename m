Return-Path: <linux-kernel-owner+w=401wt.eu-S1763016AbYECJ6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763016AbYECJ6j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 05:58:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759769AbYECJ6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 05:58:30 -0400
Received: from mjg.x.mythic-beasts.com ([93.93.128.6]:59708 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1759125AbYECJ63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 05:58:29 -0400
Date: Sat, 3 May 2008 10:58:17 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Dave Jones <davej@codemonkey.org.uk>, linux-ide@vger.kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>
Message-ID: <20080503095817.GA22208@srcf.ucam.org>
References: <20080502154458.GA10567@codemonkey.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080502154458.GA10567@codemonkey.org.uk>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: Remove Asus EEE UDMA/33 limitation.
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 02, 2008 at 11:44:58AM -0400, Dave Jones wrote:

>  static const struct ich_laptop ich_laptop[] = {
>  	/* devid, subvendor, subdev */
> +	{ 0x2653, 0x1043, 0x82d8 },	/* ICH6M on Asus Eee PC */
>  	{ 0x27DF, 0x0005, 0x0280 },	/* ICH7 on Acer 5602WLMi */
>  	{ 0x27DF, 0x1025, 0x0102 },	/* ICH7 on Acer 5602aWLMi */
>  	{ 0x27DF, 0x1025, 0x0110 },	/* ICH7 on Acer 3682WLMi */

Don't the ACPI timing methods let us work this out without requiring 
machine specific knowledge? Or is the concern that some firmware will 
let us program high modes even if the cabling isn't up to it?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
