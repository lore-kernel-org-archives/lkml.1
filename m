Return-Path: <linux-kernel-owner+w=401wt.eu-S1754554AbYHADmK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554AbYHADmK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 23:42:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751032AbYHADly
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 23:41:54 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:28600 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbYHADlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 23:41:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xvsBSAOrvE/P87gTdd7We0bkrs9DxkQg6CrbOkyPQGEIYf7NYOLQc2v1UZlsOZ7Mxo
         hXmU9WUJpHtnHE8jBmCOq+oEffRvpEG0C0Ss39ftWuMmOp0fv9AqSIBJ7ALCVp0mXmrV
         h6Ndzzn708giI/QIJD3o7JitIoGIj69Gonrm0=
Date: Thu, 31 Jul 2008 22:41:50 -0500
From: Matt Garman <matthew.garman@gmail.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: David Greaves <david@dgreaves.com>, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: 12 Veliciraptors again w/x4 card (~1gbyte/sec aggregate read)!
Message-ID: <20080801034150.GA32026@sewage.raw-sewage.fake>
References: <alpine.DEB.1.10.0807071424100.4694@p34.internal.lan> <4872A2F4.2010604@dgreaves.com> <alpine.DEB.1.10.0807080429440.17980@p34.internal.lan> <alpine.DEB.1.10.0807080438560.17980@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0807080438560.17980@p34.internal.lan>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2008 at 04:39:34AM -0400, Justin Piszcz wrote:
> On Tue, 8 Jul 2008, Justin Piszcz wrote:
>> On Tue, 8 Jul 2008, David Greaves wrote:
>>> Justin Piszcz wrote:
>>>> Each PCI-e x1 card has 1 veliciraptor on it now.
>>>> Got an x4 card wit 4 sata ports:
>>> Useful - which card?
>>
>> StarTech 4 Port PCI Express x4 SATA II Card Model PEXSATA24E
>>
>>
> Chipset: Marvell 88SX7042
> SATA Connectivity: Use four internal ports at the same time or two internal 
> and two external ports
>
> Which is fully supported in the latest kernels (didn't try an old kernel):
>
> linux-2.6.25.10/drivers/ata/sata_mv.c
>
>   /* Marvell 7042 support */
>   { PCI_VDEVICE(MARVELL, 0x7042), chip_7042 },

How have that card and the array attached to it been doing since you
originally posted this?

Doesn't that HighPoint 23xx card also use the Marvell 88SX7042 chip?
I remember seeing the threads about the HighPoint card silently
corrupting data by silently writing over parts of the disk(s) with
its own info.  I'm guessing that's not a "feature" of the Marvell
chip, but still... admittedly irrational fear here :)

It would be nice if that Supermicro 8-port SATA card (AOC-SAT2-MV8)
was available in PCIe... I wonder if it's possible to just graft
multiple SiI 3132 controllers (2 SATA each) on a single PCIe card?

