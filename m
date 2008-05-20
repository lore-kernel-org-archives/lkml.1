Return-Path: <linux-kernel-owner+w=401wt.eu-S1758821AbYETBWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758821AbYETBWS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 21:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754766AbYETBWE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 21:22:04 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:38573 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753945AbYETBWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 21:22:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PPt41yHuuP3IQzKNKh7Twu1ooXrB8GjPNm4eoKzF0XxeiXilO6tWMHsEJnNYUN5znaPnfdyFvEe1FLptxPo2QWYHhnKNbyPiSPiTaguYxM7UQAV6eRh7divWr82qNAd7V88tNgV7HEvPZvj7tikoSdPn07VlpU0eGw8gs98jMtQ=
Message-ID: <86802c440805191822v5b572d03t1568b27eb2defa4a@mail.gmail.com>
Date: Mon, 19 May 2008 18:22:00 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ciaran McCreesh" <ciaran.mccreesh@googlemail.com>
Subject: Re: kernel boot hangs after x86: insert_resorce for lapic addr after e820_reserve_resources
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <20080520014405.5eb150cd@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080518014111.4f32298b@googlemail.com>
	 <86802c440805172055x30c2c6feg441e16f5fb24f64f@mail.gmail.com>
	 <20080518164127.2236d82a@googlemail.com>
	 <86802c440805181400m5a3b4e28oeab6245e9a2ffd00@mail.gmail.com>
	 <20080518232347.7964835c@snowcone>
	 <86802c440805182043n2a4855bcw6924f6df2fbdc9f4@mail.gmail.com>
	 <20080520014405.5eb150cd@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2008 at 5:44 PM, Ciaran McCreesh
<ciaran.mccreesh@googlemail.com> wrote:
> On Sun, 18 May 2008 20:43:09 -0700
> "Yinghai Lu" <yhlu.kernel@gmail.com> wrote:
>> > ide_scan_pcibus doesn't return. I tried shoving some printks in
>> > there, but as soon as I did it instead locked up in pci_init. Is it
>> > worth continuing this approach or will doing so not give useful
>> > results anyway?
>>
>> could be pci iomem conflicts...
>> please enable CONFIG_PCI_DEBUG=y
>> and apply the following two debug patches
>
> dmesg with debugging attached.
>

the iomem allocation seems good...

can you send out /proc/iomem?

Thanks

YH
