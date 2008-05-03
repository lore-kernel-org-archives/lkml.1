Return-Path: <linux-kernel-owner+w=401wt.eu-S1758208AbYECPA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758208AbYECPA0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 11:00:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755709AbYECPAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 11:00:12 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:37041 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752961AbYECPAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 11:00:11 -0400
Date: Sat, 3 May 2008 15:51:24 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Dave Jones <davej@codemonkey.org.uk>, linux-ide@vger.kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Remove Asus EEE UDMA/33 limitation.
Message-ID: <20080503155124.004e27a7@core>
In-Reply-To: <20080503095817.GA22208@srcf.ucam.org>
References: <20080502154458.GA10567@codemonkey.org.uk>
	<20080503095817.GA22208@srcf.ucam.org>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 May 2008 10:58:17 +0100
Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> On Fri, May 02, 2008 at 11:44:58AM -0400, Dave Jones wrote:
> 
> >  static const struct ich_laptop ich_laptop[] = {
> >  	/* devid, subvendor, subdev */
> > +	{ 0x2653, 0x1043, 0x82d8 },	/* ICH6M on Asus Eee PC */
> >  	{ 0x27DF, 0x0005, 0x0280 },	/* ICH7 on Acer 5602WLMi */
> >  	{ 0x27DF, 0x1025, 0x0102 },	/* ICH7 on Acer 5602aWLMi */
> >  	{ 0x27DF, 0x1025, 0x0110 },	/* ICH7 on Acer 3682WLMi */
> 
> Don't the ACPI timing methods let us work this out without requiring 
> machine specific knowledge? 

We don't currently sniff the ACPI timing data on Intel boxes - we can do
so and there is a library routine but I'd be worried about the usual
standard of BIOS code. Right now we only do it for chipsets which are so
braindamaged we have no other choice or where the vendor specifically
implemented and intended the ACPI data to be used for this (eg Nvidia)
