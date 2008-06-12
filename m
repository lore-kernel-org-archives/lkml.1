Return-Path: <linux-kernel-owner+w=401wt.eu-S1755911AbYFLV6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911AbYFLV6U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 17:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751575AbYFLV6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 17:58:11 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:29593 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbYFLV6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 17:58:10 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: pnp changes -> suspend oops [Was: 2.6.26-rc5-mm2]
Date: Thu, 12 Jun 2008 15:57:27 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org
References: <20080609223145.5c9a2878.akpm@linux-foundation.org> <200806121522.44199.bjorn.helgaas@hp.com> <48519782.9070306@gmail.com>
In-Reply-To: <48519782.9070306@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806121557.28505.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 June 2008 03:39:14 pm Jiri Slaby wrote:
> On 06/12/2008 11:22 PM, Bjorn Helgaas wrote:
> > On Thursday 12 June 2008 03:10:04 pm Jiri Slaby wrote:
> >> On 06/11/2008 09:03 PM, Bjorn Helgaas wrote:
> >>> Before you go to all the trouble of bisecting it, can you turn on
> >>> CONFIG_PNP_DEBUG and try the following debug patch?  I think this
> >>> will prevent the oops, but it's just papering over the real problem,
> >>> so please capture the complete dmesg log.
> >> ACPI: PCI interrupt for device 0000:00:02.0 disabled
> >> serial 00:07: disabled
> >> serial 00:06: disabled
> >> ACPI handle has no context!
> >> ACPI: PCI interrupt for device 0000:00:1d.7 disabled
> >> ...
> >> serial 00:06:   no dma resource to encode!
> >> serial 00:06: activated
> >> serial 00:07:   no dma resource to encode!
> >> serial 00:07: activated
> >> ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 16
> > 
> > Interesting.  I wonder why a serial device would have a DMA resource.
> > We encode resources by following a template from _CRS, so evidently
> > that template had a DMA resource.  Or something deeper is wrong.
> > 
> > Can you send me the rest of that dmesg log?
> 
> Below.

Thanks, but it looks like CONFIG_PNP_DEBUG is not turned on.  Can
you turn that on and capture the log again, please?

Bjorn

