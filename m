Return-Path: <linux-kernel-owner+w=401wt.eu-S1754002AbYGVUMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002AbYGVUMj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 16:12:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752012AbYGVUMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 16:12:31 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:59073 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbYGVUMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 16:12:31 -0400
Message-ID: <48863FB4.9080500@keyaccess.nl>
Date: Tue, 22 Jul 2008 22:14:44 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Fabio Comolli <fabio.comolli@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: New conflict message in latest GIT
References: <b637ec0b0807221156x46d550a1h4180d6d624daeeb@mail.gmail.com> <48863C46.1060704@keyaccess.nl>
In-Reply-To: <48863C46.1060704@keyaccess.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22-07-08 22:00, Rene Herman wrote:

>> Linus' GIT tree 2.6.26-05752-g93ded9b shows this message:

There doesn't seem to be a g93ded9b in Linus' tree as of now. What tree 
are you on and does it perhaps already include the below patch?

This one:

http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.26-rc8/2.6.26-rc8-mm1/broken-out/pnp-have-quirk_system_pci_resources-include-io-resources.patch

>> i801_smbus 0000:00:1f.3: PCI INT B -> GSI 19 (level, low) -> IRQ 19
>> ACPI: I/O resource 0000:00:1f.3 [0x18e0-0x18ff] conflicts with ACPI
>> region SMBI [0x18e0-0x18ef]
>> ACPI: Device needs an ACPI driver
>>
>> There is no equivalent in 2.6.26 or previous kernels.
> 
> [ snip ]
> 
>> 00:1f.3 SMBus: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family)
> 
> I believe this message in itself needn't be a problem but the code 
> producing this warning isn't new...
> 
> Bjorn, this reminds me of the:
> 
> pnp-have-quirk_system_pci_resources-include-io-resources.patch
> 
> in Andrew's tree that I need to have my soundcard not fail due to the IO 
> resource being claimed by PNPACPI. The fact that I needed it was new to 
> 2.6.26 (but going back to 2.6.25 I all of a sudden also needed it there 
> which made me conclude that some BIOS reconfig had occured).
> 
> ACPI isn't doing odd things I hope?

Rene.
