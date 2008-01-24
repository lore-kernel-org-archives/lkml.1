Return-Path: <linux-kernel-owner+w=401wt.eu-S1757420AbYAXUM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757420AbYAXUM6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 15:12:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756822AbYAXUMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 15:12:48 -0500
Received: from az33egw01.freescale.net ([192.88.158.102]:57907 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754310AbYAXUMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 15:12:47 -0500
Date: Thu, 24 Jan 2008 14:12:26 -0600
From: Scott Wood <scottwood@freescale.com>
To: Poonam_Aggrwal-b10812 <b10812@freescale.com>
Cc: kumar.gala@freescale.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       rubini@vision.unipv.it, linuxppc-dev@ozlabs.org,
       michael.barkowski@freescale.com, rich.cutler@freescale.com,
       timur@freescale.com, ashish.kalra@freescale.com
Subject: Re: [PATCH UCC TDM 3/3 ] Modified Documentation to explain dts
	entries for TDM driver
Message-ID: <20080124201226.GA3926@loki.buserror.net>
References: <Pine.LNX.4.64.0801241022070.27491@linux121>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0801241022070.27491@linux121>
User-Agent: Mutt/1.5.17 (2007-12-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2008 at 10:24:13AM +0530, Poonam_Aggrwal-b10812 wrote:
> +  ix) Baud Rate Generator (BRG)
> +
> +  Required properties:
> +  - compatible : shpuld be "fsl,cpm-brg"
> +  - fsl,brg-sources : define the input clock for all 16 BRGs. The input
> +    clock source could be 1 to 24 for CLK1 to CLK24. Zero means that the
> +    particular BRG will be driven by QE clock(BRGCLK).

Should also have a clock-frequency property to specify what BRGCLK is.

-Scott
