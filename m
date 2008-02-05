Return-Path: <linux-kernel-owner+w=401wt.eu-S1756750AbYBEQni@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750AbYBEQni (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 11:43:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752602AbYBEQnc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 11:43:32 -0500
Received: from gate.crashing.org ([63.228.1.57]:46598 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751639AbYBEQna (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 11:43:30 -0500
Date: Tue, 5 Feb 2008 10:43:18 -0600
From: Matt Porter <mporter@kernel.crashing.org>
To: Zhang Wei <wei.zhang@freescale.com>
Cc: galak@kernel.crashing.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 6/6] Change the kernel configurated RapidIO system size to auto-probing.
Message-ID: <20080205164318.GC20177@gate.crashing.org>
References: <1201689053956-git-send-email-wei.zhang@freescale.com> <12016890621727-git-send-email-wei.zhang@freescale.com> <120168907160-git-send-email-wei.zhang@freescale.com> <12016890773706-git-send-email-wei.zhang@freescale.com> <12016890832943-git-send-email-wei.zhang@freescale.com> <12016890873190-git-send-email-wei.zhang@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12016890873190-git-send-email-wei.zhang@freescale.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2008 at 06:30:53PM +0800, Zhang Wei wrote:
> The RapidIO system size will auto probe in RIO setup. The route
> table and rionet_active in rionet.c are changed to be allocated
> dynamically according the system size.

<snip>

> +	port->sys_size = (in_be32((priv->regs_win + RIO_PEF_CAR))
> +					& RIO_PEF_CTLS) >> 4;
> +	dev_info(&dev->dev, "RapidIO Common Transport System size: %d\n",
> +			port->sys_size ? 65536 : 256);
> +

This is much nicer than the original hardcoded transport size
implementation.

-Matt
