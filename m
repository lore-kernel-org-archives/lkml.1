Return-Path: <linux-kernel-owner+w=401wt.eu-S1752174AbYL3NPF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174AbYL3NPF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 08:15:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751702AbYL3NOw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 08:14:52 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:40253 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515AbYL3NOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 08:14:51 -0500
Date: Tue, 30 Dec 2008 13:14:47 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: 2.6.28: How come some kernel options cannot be disabled for non-existent hardware?
Message-ID: <20081230131447.GA14942@srcf.ucam.org>
References: <alpine.DEB.1.10.0812300641390.11356@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0812300641390.11356@p34.internal.lan>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 30, 2008 at 07:25:42AM -0500, Justin Piszcz wrote:

> It still shows up as enabled and it is in dmesg shown above.  How come 
> some kernel options are enabled and cannot (easily?) be disabled for 
> hardware that does not exist in my machine?

It's enabled by the ATA_ACPI support so libata can handle ACPI-based 
drive hotswaps. You can check these by looking at the help for an option 
in make menuconfig. That'll tell you what's selecting an option.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
