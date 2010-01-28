Return-Path: <linux-kernel-owner+w=401wt.eu-S1755616Ab0A1UTO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616Ab0A1UTO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 15:19:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754257Ab0A1UTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 15:19:14 -0500
Received: from mail-iw0-f172.google.com ([209.85.223.172]:47022 "EHLO
	mail-iw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159Ab0A1UTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 15:19:13 -0500
X-Greylist: delayed 424 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Jan 2010 15:19:12 EST
MIME-Version: 1.0
X-Originating-IP: [66.187.234.200]
In-Reply-To: <aacba7e1001270814s3ebdcc62i39d6ed0efeb194eb@mail.gmail.com>
References: <aacba7e1001260704m27c99a0dy6c3f50c38ce6b430@mail.gmail.com>
	 <20100126160243.018b87e3@lxorguk.ukuu.org.uk>
	 <aacba7e1001260819k24088c81m14b4c702fccddd29@mail.gmail.com>
	 <72dbd3151001261251s606ebf00h86c2ce63293305b6@mail.gmail.com>
	 <aacba7e1001261621v6abb4270i996a28d19c9f7d7@mail.gmail.com>
	 <be3a4a1001270739u2c0cecfevd87269d947ff7dc0@mail.gmail.com>
	 <aacba7e1001270814s3ebdcc62i39d6ed0efeb194eb@mail.gmail.com>
Date: Thu, 28 Jan 2010 15:12:07 -0500
Message-ID: <be3a4a1001281212h73ba1bd5ja8e275679f3554d7@mail.gmail.com>
Subject: Re: [PATCH] ata: Disable NCQ for Crucial M225 brand SSDs
From: Jarod Wilson <jarod@wilsonet.com>
To: Vishal Rao <vishalrao@gmail.com>
Cc: David Rees <drees76@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       jgarzik@pobox.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, trivial@kernel.org, stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 27, 2010 at 11:14 AM, Vishal Rao <vishalrao@gmail.com> wrote:
> 2010/1/27 Jarod Wilson <jarod@wilsonet.com>:
>> How to define a group gets... Messy. Just as a data point, my own
>> Barefoot-based SSD, an OCZ Vertex, has no NCQ-related problems
>> whatsoever, so far as I know. Its currently hooked to a Zotac ION
>> board, which has ahci-driven sata controllers of some sort, was
>> previously in a Dell Studio Hybrid, where it also worked just fine.
>
> Thanks for data point. I'm personally hoping for other Crucial users
> specifically.
>
> Is NCQ enabled - if you grep dmesg for ata ?

$ dmesg | grep -i ncq
ahci 0000:00:0b.0: flags: 64bit ncq sntf led pmp pio slum part sxs
ata1.00: 62533296 sectors, multi 16: LBA48 NCQ (depth 31/32), AA


> The kernel already appears to blacklist (disable NCQ for) OCZ
> SSD models with firmware version "02.10104".

Here's what I've got:

ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: ATA-7: OCZ-VERTEX 1275, 00.P97, max UDMA/133
ata1.00: 62533296 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
ata1.00: configured for UDMA/133
scsi 0:0:0:0: Direct-Access     ATA      OCZ-VERTEX 1275  00.P PQ: 0 ANSI: 5


-- 
Jarod Wilson
jarod@wilsonet.com
