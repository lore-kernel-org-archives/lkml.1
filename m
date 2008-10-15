Return-Path: <linux-kernel-owner+w=401wt.eu-S1752942AbYJOJNi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942AbYJOJNi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 05:13:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751843AbYJOJNa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 05:13:30 -0400
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:34014 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbYJOJN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 05:13:29 -0400
Subject: Re: [PATCH] Enable console on PCI serial devices
From: Paul Bolle <pebolle@tiscali.nl>
To: n0ano@n0ano.com
Cc: Yinghai Lu <yinghai@kernel.org>, donald.d.dugger@intel.com,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <20081014233031.GB14490@xolotl.n0ano.com>
References: <200810142231.m9EMV95O002974@los-vmm.sc.intel.com>
	 <86802c440810141539x97ceaa4meaab109fae3d9d4c@mail.gmail.com>
	 <20081014233031.GB14490@xolotl.n0ano.com>
Content-Type: text/plain
Date: Wed, 15 Oct 2008 11:13:19 +0200
Message-Id: <1224061999.25929.7.camel@test.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.0 (2.24.0-3.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-10-14 at 17:30 -0600, n0ano@n0ano.com wrote:
> -		uart[8250],io,<addr>[,options]
> -		uart[8250],mmio,<addr>[,options]
> +		uart[8250],io,<addr>[,options[,clk]]
> +		uart[8250],mmio,<addr>[,options[,clk]]
>  			Start an early, polled-mode console on the 8250/16550
>  			UART at the specified I/O port or MMIO address,
>  			switching to the matching ttyS device later.  The
> -			options are the same as for ttyS, above.
> +			"options" are the same as for ttyS, above.  "clk"
> +			is the crystal frequency which defaults to 1843200
> +			(115200 * 16) but some hardware uses different
> +			crystal.

Shouldn't the earlycon entry be updated for the "clk" stuff too?


Paul Bolle

