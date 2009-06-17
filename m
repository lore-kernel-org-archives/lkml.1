Return-Path: <linux-kernel-owner+w=401wt.eu-S1763475AbZFQBNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763475AbZFQBNR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 21:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759208AbZFQBNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 21:13:07 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:6561 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009AbZFQBNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 21:13:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YjRpM+D3lfY1M6ACAIU1CMjXxOtvg4STE6MCQim/yiekD8z6IJV+q8lbz6KrAp4Tak
         zGat+xyt5xgCVlz9TsZuRrMJH4IOAzYWTEpXqVcbmUp8XA5i+yqCTdiPog0tYZvU3NEr
         1Ie8CevsVgvCMnu++xjZLrVZiZRrLI3AOnR40=
MIME-Version: 1.0
In-Reply-To: <1245200912.21602.2.camel@pasglop>
References: <4A37DB0F.7060801@freescale.com> <200906162002.12376.arnd@arndb.de>
	 <1245197925.21602.0.camel@pasglop>
	 <20090617093654B.fujita.tomonori@lab.ntt.co.jp>
	 <c384c5ea0906161756j4b701abfj2a8908b9c93ddd04@mail.gmail.com>
	 <1245200912.21602.2.camel@pasglop>
Date: Wed, 17 Jun 2009 03:13:07 +0200
Message-ID: <c384c5ea0906161813v26b3a739h8ce36e395841df35@mail.gmail.com>
Subject: Re: PowerPC PCI DMA issues (prefetch/coherency?)
From: Leon Woestenberg <leon.woestenberg@gmail.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, arnd@arndb.de,
       scottwood@freescale.com, chris.pringle@oxtel.com,
       linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Benjamin,

On Wed, Jun 17, 2009 at 3:08 AM, Benjamin
Herrenschmidt<benh@kernel.crashing.org> wrote:
> On Wed, 2009-06-17 at 02:56 +0200, Leon Woestenberg wrote:
>> I use pci_map_sg(), have the device perform either DMA master reads or
>> writes to the bus address using PCIe.
>> After that, I use pci_unmap_sg().
>>
>> My assumption is that pci_unmap_sg() either makes the cache coherent
>> or invalidated and thus I do not need to take further actions.
>> This is on a MPC83xx or 85xx system.
>>
>> Is this assumption correct?
>
> It is, as far as I understand things :-) Those APIs are fun.
>
> You should only need the explicit sync calls if you are going to peek or
> poke at the DMA mapped memory before you unmap it.
>
Thanks, then at least I understand things in the corr^H^H^H^Hsame way :-)

And btw, I hadn't seen any data mismatch yet.

Regards,
-- 
Leon 'likewise' Woestenberg
