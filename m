Return-Path: <linux-kernel-owner+w=401wt.eu-S1756647AbYGQGsa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756647AbYGQGsa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 02:48:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753572AbYGQGsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 02:48:22 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:33671 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626AbYGQGsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 02:48:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=KoQtzOgoUnKGAnhgCrA8qtqljAoYCFMU5OwZjhmkEG4fRBNVQ/BSzU3t7H+p7HPqIr
         CFlv6whYpLP9sKMiNnpsScjToGoKMcgF1zNJy/w5m3mb+hgbeufEAjEQ/2z/1JFrsohK
         8y0aI55kjJdU3acyO3cWf3DdxZmASOphzgfeU=
Message-ID: <86802c440807162348m6d05b912x7b3f655d7f9efb93@mail.gmail.com>
Date: Wed, 16 Jul 2008 23:48:19 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Jack Howarth" <howarth@bromo.msbb.uc.edu>
Subject: Re: 2.6.26-rc9-git9 doesn't boot on Macintel
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <20080717061825.GA19582@bromo.msbb.uc.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <86802c440807160136m6af981b2u6a37cabb8e33a629@mail.gmail.com>
	 <86802c440807161029n7e0dac98x1ec260879204b6f0@mail.gmail.com>
	 <86802c440807161535n3a4d6891n6f7c16bd4e1f19c3@mail.gmail.com>
	 <20080717004004.GA17792@bromo.msbb.uc.edu>
	 <86802c440807161749u2f5c1eben618e05c6e254fedd@mail.gmail.com>
	 <20080717023538.GA18329@bromo.msbb.uc.edu>
	 <86802c440807161959s10666027k5297af1d657ff4fa@mail.gmail.com>
	 <20080717034418.GA18951@bromo.msbb.uc.edu>
	 <86802c440807162113g4cea3bd9ic71210330417032b@mail.gmail.com>
	 <20080717061825.GA19582@bromo.msbb.uc.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2008 at 11:18 PM, Jack Howarth
<howarth@bromo.msbb.uc.edu> wrote:
> YH,
>  Using the debug patches and your mmconfig patch as well as the kernel
> options 'debug initcall_debug apic=verbose pci=routeirq", I see the following
> messages that don't scroll off screen...
>
> PCI: 0000:00:1f.1 reg 10 io port: [ 40d8, 40df]
> PCI: 0000:00:1f.1 reg 14 io port: [ 40ec, 40ef]
> PCI: 0000:00:1f.1 reg 18 io port: [ 40d0, 40d7]
> PCI: 0000:00:1f.1 reg 1c io port: [ 40e8, 40eb]
> PCI: 0000:00:1f.1 reg 20 io port: [ 40b0, 40bf]
> pci 0000:00.1f.1: calling pci_fixup_transparent_bridge+0x0/0x2a
> PCI: Found 0000:00:1f.2 [8086/27c4] 000101 00
> PCI: 0000:00:1f.2 reg 10 io port: [ 40c8, 40cf]
> PCI: 0000:00:1f.2 reg 14 io port: [ 40e4, 40e7]
> PCI: 0000:00:1f.2 reg 18 io port: [ 40c0, 40c7]
> PCI: 0000:00:1f.2 reg 1c io port: [ 40e0, 40e3]
> PCI: 0000:00:1f.2 reg 20 io port: [ 40a0, 40af]
> PCI: 0000:00:1f.2 reg 24 32bit mmio: [d8405000, d84053ff]
> pci: 0000:00:1f.2 calling pci_fixup_transparent_bridge+0x0/0x2a
> PCI: Found 0000:00:1f.3 [8086/27da] 000c05 00
> PCI: 0000:00:1f.3 reg 20 io port: [ efa0, efbf]
> PCI: 0000:00:1f.3: calling pci_fixup_transparent_bridge+0x0/0x2a
> PCI: Fixups for bus 0000:00
> PCI: Scanning behind PCI bridge 0000:00:01.0, config 010100, pass 0
> PCI: Scanning bus 0000:01
> PCI: Found 0000:01:00.0 [1002/71c5] 000300 00
> PCI: 0000:00:01:00.0 reg 10 32bit mmio: [c0000000, cfffffff]
> PCI: 0000:00:01:00.0 reg 14 io port: [ 3000, 30ff]
> PCI: 0000:00:01:00.0 reg 18 32bit mmio: [d8300000, d830ffff]
>
should get
PCI: Fixups for bus 0000:01
PCI: Transparent bridge - 0000:00:01.0
PCI: bridge 0000:00:01.0 io port: [3000, 3fff]
PCI: bridge 0000:00:01.0 32bit mmio: ...
PCI: Bus scan for 0000:01 returning with max=01

Do you have CONFIG_PCIEASPM in your config?

YH
