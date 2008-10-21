Return-Path: <linux-kernel-owner+w=401wt.eu-S1754481AbYJUWIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481AbYJUWIT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 18:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751878AbYJUWIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 18:08:09 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:24749 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779AbYJUWII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 18:08:08 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: n0ano@n0ano.com
Subject: Re: [PATCH] Enable console on PCI serial devices
Date: Tue, 21 Oct 2008 16:08:03 -0600
User-Agent: KMail/1.9.9
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, donald.d.dugger@intel.com,
       linux-kernel@vger.kernel.org
References: <200810142231.m9EMV95O002974@los-vmm.sc.intel.com> <200810201311.06602.bjorn.helgaas@hp.com> <20081021200841.GL14490@xolotl.n0ano.com>
In-Reply-To: <20081021200841.GL14490@xolotl.n0ano.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200810211608.04121.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 21 October 2008 02:08:41 pm n0ano@n0ano.com wrote:
>                         Start an early, polled-mode console on the 8250/16550
>                         UART at the specified I/O port or MMIO address,
>                         switching to the matching ttyS device later.  The
> -                       options are the same as for ttyS, above.
> +                       "options" are the same as for ttyS, above.  "base"
> +                       is base baud, defaults to 115200, which is used to
> +                       calculate the divisor for the crystal frequency
> +                       (typically this is the fastest baud rate supported
> +                       by the uart).
> 

Down to nits now :-)  That last sentence would be clearer to me if it
said '(typically "base" is the fastest baud rate supported by the UART).'
I capitalized UART to match the one earlier.

Bjorn
