Return-Path: <linux-kernel-owner+w=401wt.eu-S1754584AbYERDzb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584AbYERDzb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 23:55:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751712AbYERDzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 23:55:21 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:18101 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbYERDzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 23:55:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XlHRflJsdJlrioXli+u8xv5wZ/+9f5EWFMFmEh/OazJ5OB+t/G07Z3VEJfNpcocZcr62OUpyXfJLkIeJ3Ap+eHuxqGJtUs0Hs+mKFvsDb3MaaqkD5rhV/sTHi7iZa8jqCWvkSnE+Te/wZlelmDvlCqWII3j8NqU3DZEkpKnrpuk=
Message-ID: <86802c440805172055x30c2c6feg441e16f5fb24f64f@mail.gmail.com>
Date: Sat, 17 May 2008 20:55:20 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ciaran McCreesh" <ciaran.mccreesh@googlemail.com>
Subject: Re: kernel boot hangs after x86: insert_resorce for lapic addr after e820_reserve_resources
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <20080518014111.4f32298b@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080518014111.4f32298b@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 17, 2008 at 5:41 PM, Ciaran McCreesh
<ciaran.mccreesh@googlemail.com> wrote:
> The commit 3def3d6ddf43dbe20c00c3cbc38dfacc8586998f (x86:
> insert_resorce for lapic addr after e820_reserve_resources) causes my
> x86_64 box to to lock up early on in the boot process. Reverting only
> this commit with current git head gives a successful boot.
>
> The last messages outputted to the screen with a failed boot are:
>
>    pci 0000:00:13.2: OHCI: BIOS handoff failed (BIOS bug?) 00000184
>    Clocksource tsc unstable (delta = 475235503 ns)
>
> The handoff message appears not to be related, and occurs with all
> kernels. The 'clocksource' message appears only with the above commit.
>
> The box has an Abit F-190HD motherboard with a Q6600 CPU. A .config,
> dmesg from git head with the above commit reverted and lspci -v are
> attached.
>
> What further information can I provide to help work this issue out?

can you try to boot with apic=verbose? please don't revert that patch...

wonder if init_apic_mapping need some delay with that strange chipset.

YH
