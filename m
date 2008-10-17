Return-Path: <linux-kernel-owner+w=401wt.eu-S1757314AbYJQRHE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757314AbYJQRHE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 13:07:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754429AbYJQRGr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 13:06:47 -0400
Received: from willie.n0ano.com ([64.66.241.76]:33827 "EHLO xolotl.n0ano.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754162AbYJQRGr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 13:06:47 -0400
From: n0ano@n0ano.com
Date: Fri, 17 Oct 2008 11:06:38 -0600
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: n0ano@n0ano.com, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       donald.d.dugger@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Enable console on PCI serial devices
Message-ID: <20081017170638.GJ14490@xolotl.n0ano.com>
References: <200810142231.m9EMV95O002974@los-vmm.sc.intel.com> <200810170846.41032.bjorn.helgaas@hp.com> <20081017153652.GH14490@xolotl.n0ano.com> <200810171039.53395.bjorn.helgaas@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810171039.53395.bjorn.helgaas@hp.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2008 at 10:39:52AM -0600, Bjorn Helgaas wrote:
>... 
> Here's another possibility, maybe too wordy, but maybe more straightforward:
> 
> +		uart[8250],mmio,<addr>[,options[,clock]]
> 
> +			"clock" is the frequency of the crystal driving
> +			the UART clock (typically sixteen times the
> +			fastest baud rate supported by the UART).
> 
> +		port->uartclk = simple_strtoul(options, NULL, 0);
> 

We could do that but now the `clock' value becomes a very large
number that is very magic.  Putting in the highest baud rate seems
to make more sense than some magic number.

-- 
Don Dugger
"Censeo Toto nos in Kansa esse decisse." - D. Gale
n0ano@n0ano.com
Ph: 303/443-3786
