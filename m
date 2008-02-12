Return-Path: <linux-kernel-owner+w=401wt.eu-S1758940AbYBLCBb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758940AbYBLCBb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 21:01:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753096AbYBLCBW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 21:01:22 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:37106 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbYBLCBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 21:01:21 -0500
Date: Mon, 11 Feb 2008 18:20:46 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: Re: [PATCH 4/4] x86_64: check msr to get mmconfig for amd family 10h
 opteron v3
In-reply-to: <20080211170944.8b567a89.akpm@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: greg@kroah.com, mingo@elte.hu, linux-kernel@vger.kernel.org
Message-id: <200802111820.47244.yinghai.lu@sun.com>
Organization: SUN
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200802111643.17265.yinghai.lu@sun.com>
 <200802111648.35299.yinghai.lu@sun.com>
 <20080211170944.8b567a89.akpm@linux-foundation.org>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 February 2008 05:09:44 pm Andrew Morton wrote:
> On Mon, 11 Feb 2008 16:48:35 -0800
> Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:
> 
> > From: Yinghai Lu <Yinghai.Lu@Sun.COM>
> > 
> > so even booting kernel with acpi=off or even MCFG is not there, we still can
> > use MMCONFIG.
> > 
> 
> This patch threw a big reject.  I didn't check why.
> 
> 
> > +		pci_direct_conf1.read(0, bus, devfn, 0, 4, &l);
> 
> When I fixed the reject, compilation failed here.
> 
> arch/x86/pci/mmconfig-shared.c: In function 'pci_mmcfg_check_hostbridge':
> arch/x86/pci/mmconfig-shared.c:214: error: 'pci_direct_conf1' undeclared (first use in this function)
> 
> 
> What kernel are you patching?
> 

linus tree. 

other three are ok?

YH
