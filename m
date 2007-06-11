Return-Path: <linux-kernel-owner+w=401wt.eu-S1755948AbXFKSLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948AbXFKSLR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 14:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752608AbXFKSLH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 14:11:07 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:33649 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793AbXFKSLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 14:11:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=hJuImzwOADxh87N4g3hDnWsxgufyUylxcFZyVutkUeRsyJMwvVOcdk4zMLwnF58gLZ3Nabqrj4YXfyO2+z1DeXE6Y6+xM4i40BQ9tUFc+0xdmOmvnSAewv0XqlYw0Sab4nsitgt5YkPGMDpfqGH4a6V7X7ydI7+cnWU2Nuk6jAA=
Message-ID: <86802c440706111111s3f52e572uc90efaf18652538e@mail.gmail.com>
Date: Mon, 11 Jun 2007 11:11:05 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [RFC] Runtime allocation of PCI resources
Cc: "Matthew Garrett" <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, gregkh@suse.de
In-Reply-To: <p73d502uzsj.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070611165112.GA30272@srcf.ucam.org>
	 <p73d502uzsj.fsf@bingen.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 Jun 2007 20:11:24 +0200, Andi Kleen <andi@firstfloor.org> wrote:
> Matthew Garrett <mjg59@srcf.ucam.org> writes:
>
> > BIOS authors don't always program all the features of hardware. This is
> > often the case for Intel IDE controllers, which are usually able to run
> > in AHCI mode but are rarely configured to do so. Reprogramming them is
> > easy enough other than the requirement for some MMIO space. If the BIOS
> > hasn't allocated this, it's necessary for us to do so manually.
>
> Traditionally we've had bad experiences forcing hardware to do something
> the BIOS didn't consider. e.g. occasionally the BIOS has good reasons
> to not allow it; maybe it knows about some errata or other problem
> the kernel doesn't.
>
> If you do this then don't make it default at least, but only allow
> to force it use an option.

Esp for AMD system with several Hypertranport chain. try to allocate
pci resource in kernel  also need some region adjust in NB
configuration space.

So leave some work to ACPI DSDT AML code at least

YH
