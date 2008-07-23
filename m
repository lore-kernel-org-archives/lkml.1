Return-Path: <linux-kernel-owner+w=401wt.eu-S1753435AbYGWHSQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435AbYGWHSQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 03:18:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751141AbYGWHSC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 03:18:02 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:40385 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbYGWHSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 03:18:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=xrzcCE/RnTSvK4HrMGd/Mqq5ZMDyhZ1hEOYcCgdw4WNcZQ5bDTiIf4F1NWgLkuv6cA
         RrjIx4oXpjCnADnRYsSjQOW8blrZo/kOC2+u4aJsINBp6l5OsmtHLDTBKe5Z83IECzWP
         iP8hOxtOLoXfXfwyRTnYAhD8vvylYKbrfz5es=
Message-ID: <b637ec0b0807230017w39ecd5bapc9a6afe29a39d5f3@mail.gmail.com>
Date: Wed, 23 Jul 2008 09:17:59 +0200
From: "Fabio Comolli" <fabio.comolli@gmail.com>
To: "Rene Herman" <rene.herman@keyaccess.nl>
Subject: Re: New conflict message in latest GIT
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@osdl.org>, "Bjorn Helgaas" <bjorn.helgaas@hp.com>
In-Reply-To: <48863FB4.9080500@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b637ec0b0807221156x46d550a1h4180d6d624daeeb@mail.gmail.com>
	 <48863C46.1060704@keyaccess.nl> <48863FB4.9080500@keyaccess.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Rene.

On Tue, Jul 22, 2008 at 10:14 PM, Rene Herman <rene.herman@keyaccess.nl> wrote:
> On 22-07-08 22:00, Rene Herman wrote:
>
>>> Linus' GIT tree 2.6.26-05752-g93ded9b shows this message:
>
> There doesn't seem to be a g93ded9b in Linus' tree as of now. What tree are
> you on and does it perhaps already include the below patch?
>

Well, this is strange because it should be a clone of Linus' tree. I
will re-clone it tonight.

> This one:
>
> http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.26-rc8/2.6.26-rc8-mm1/broken-out/pnp-have-quirk_system_pci_resources-include-io-resources.patch
>

I did not add it manually for sure. By the way, I don't see any ACPI
related problems with this kernel.

Regards,
Fabio





>>> i801_smbus 0000:00:1f.3: PCI INT B -> GSI 19 (level, low) -> IRQ 19
>>> ACPI: I/O resource 0000:00:1f.3 [0x18e0-0x18ff] conflicts with ACPI
>>> region SMBI [0x18e0-0x18ef]
>>> ACPI: Device needs an ACPI driver
>>>
>>> There is no equivalent in 2.6.26 or previous kernels.
>>
>> [ snip ]
>>
>>> 00:1f.3 SMBus: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family)
>>
>> I believe this message in itself needn't be a problem but the code
>> producing this warning isn't new...
>>
>> Bjorn, this reminds me of the:
>>
>> pnp-have-quirk_system_pci_resources-include-io-resources.patch
>>
>> in Andrew's tree that I need to have my soundcard not fail due to the IO
>> resource being claimed by PNPACPI. The fact that I needed it was new to
>> 2.6.26 (but going back to 2.6.25 I all of a sudden also needed it there
>> which made me conclude that some BIOS reconfig had occured).
>>
>> ACPI isn't doing odd things I hope?
>
> Rene.
>
