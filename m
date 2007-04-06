Return-Path: <linux-kernel-owner+w=401wt.eu-S933140AbXDFQZq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933140AbXDFQZq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 12:25:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933142AbXDFQZq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 12:25:46 -0400
Received: from atlrel6.hp.com ([156.153.255.205]:49172 "EHLO atlrel6.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933140AbXDFQZp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 12:25:45 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Keith Owens <kaos@ocs.com.au>
Subject: Re: PNPACPI probes serial twice, messes up serial console
Date: Fri, 6 Apr 2007 10:25:24 -0600
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, len.brown@intel.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Russell King <rmk+lkml@arm.linux.org.uk>
References: <11466.1174537431@kao2.melbourne.sgi.com>
In-Reply-To: <11466.1174537431@kao2.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704061025.24433.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 March 2007 22:23, Keith Owens wrote:
> The aim of the patch looks sensible, but it will not compile for
> 2.6.21-rc4.  8250_x86.c tests pnp_platform_devices, which does not
> exist.  Also the combination of CONFIG_SERIAL_8250_X86=y and
> CONFIG_SERIAL_8250_PNP=m would result in 8250_x86.o being built into
> vmlinux but referring to serial8250_nopnp in module 8250_pnp.o, kernel
> to module references are tricky.

I posted an updated series of patches a couple days ago:
  http://lkml.org/lkml/2007/4/4/540

Let me know whether they work for you.

Bjorn
