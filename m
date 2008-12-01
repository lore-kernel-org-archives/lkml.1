Return-Path: <linux-kernel-owner+w=401wt.eu-S1753869AbYLAU3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869AbYLAU3S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 15:29:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751355AbYLAU3E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 15:29:04 -0500
Received: from outbound-mail-119.bluehost.com ([69.89.22.19]:56880 "HELO
	outbound-mail-119.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751507AbYLAU3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 15:29:03 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=rVSm6bqudkPmJKHUU+AvIlrGICElqz5PAIybD4T4nIkuBdsvbSJ4PPohP8RHNYOEDVEnsUQV60Phj3mdqVgLpCVTa1sa5NGN1UBgBdcS/MXtJ2GDKI21bwbsx4x52z2g;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] resource: allow MMIO exclusivity for device drivers
Date: Mon, 1 Dec 2008 12:28:58 -0800
User-Agent: KMail/1.10.1 (Linux/2.6.27.5-41.fc9.x86_64; KDE/4.1.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
References: <20081123130302.22c197d5@infradead.org>
In-Reply-To: <20081123130302.22c197d5@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812011229.00432.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, November 23, 2008 1:03 pm Arjan van de Ven wrote:
> From 18cafd344e3de33b5e4feddac5657c1f5fed2d56 Mon Sep 17 00:00:00 2001
> From: Arjan van de Ven <arjan@linux.intel.com>
> Date: Wed, 22 Oct 2008 19:55:31 -0700
> Subject: [PATCH] resource: allow MMIO exclusivity for device drivers
>
> Device drivers that use pci_request_regions() (and similar APIs) have a
> reasonable expectation that they are the only ones accessing their device.
> As part of the e1000e hunt, we were afraid that some userland (X or some
> bootsplash stuff) was mapping the MMIO region that the driver thought it
> had exclusively via /dev/mem or via various sysfs resource mappings.
>
> This patch adds the option for device drivers to cause their reserved
> regions to the "banned from /dev/mem use" list, so now both kernel memory
> and device-exclusive MMIO regions are banned.
> NOTE: This is only active when CONFIG_STRICT_DEVMEM is set.
>
> In addition to the config option, a kernel parameter iomem=relaxed is
> provided for the cases where developers want to diagnose, in the field,
> drivers issues from userspace.
>
> Reviewed-by: Matthew Wilcox <willy@linux.intel.com>
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>

Applied to my linux-next branch, thanks Arjan & Matthew.

Jesse
