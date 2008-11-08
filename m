Return-Path: <linux-kernel-owner+w=401wt.eu-S1754535AbYKHL5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535AbYKHL5k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 06:57:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753277AbYKHL5W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 06:57:22 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:29971 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753167AbYKHL5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 06:57:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=UpHlkpFEsc94ORkrTTIfMvbIB6qPphRbv94EoSfruM97icirsEmJnpQXhDb9k2tYzj
         kGqByvDgnTjlGge7NIXckmHIRLHNhxbJ1tegSQgjfOL4UcNwRv9P966Ll58ERdZMZ1e+
         4YJ8Rl0oCtl2B6Jghk129kejtFDf72FezT4Xc=
Message-ID: <49157E9B.8070709@gmail.com>
Date: Sat, 08 Nov 2008 12:57:15 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Nobin Mathew <nobin.mathew@gmail.com>
CC: Grant Grundler <grundler@parisc-linux.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, Robert Hancock <hancockr@shaw.ca>
Subject: Re: sharing interrupt between PCI device
References: <fa.h7+lofM1lpbRM5V4/ti5d7RwXuM@ifi.uio.no>	 <4910E8AC.7050407@shaw.ca>	 <8d6898730811042349p19e65556l8e1c851b27758d5@mail.gmail.com>	 <49115AFC.2030400@gmail.com>	 <8d6898730811050120k10a20e4em744be45e04cfba94@mail.gmail.com>	 <20081108075729.GA15107@colo.lackof.org> <491560C7.7050607@gmail.com> <8d6898730811080353q6cae6620qbf203735d592a40e@mail.gmail.com>
In-Reply-To: <8d6898730811080353q6cae6620qbf203735d592a40e@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/2008 12:53 PM, Nobin Mathew wrote:
> This is what happens when we insert and remove the hp-ilo driver (dmesg logs).
> 
> for remove
> ACPI: PCI interrupt for device 0000:01:04.2 disabled
> 
> 
> when inserted
> PCI: Enabling device 0000:01:04.2 (0114 -> 0117)
> ACPI: PCI Interrupt 0000:01:04.2[B] -> GSI 23 (level, low) -> IRQ 225

Please provide lspci -nnvvxxx and full dmesg with this use case.
