Return-Path: <linux-kernel-owner+w=401wt.eu-S1753323AbYKDBgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323AbYKDBgS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 20:36:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751036AbYKDBgF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 20:36:05 -0500
Received: from rv-out-0506.google.com ([209.85.198.239]:58971 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947AbYKDBgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 20:36:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=Cu3I1034nYPm05lIIa5bFpIghfA6M4DZGXufdFxoWpQC3IeS/LAc3hxAxT/dhySJti
         Uky4/2fPkVjJkDrnGjON1k/xPr2s0qlcivKRwFr3zG/UcqjOkx7leg9AFM7csYhAUB44
         p8GgjimGA62LDqIaudrE+oEHLi/r4aX2TClXk=
Message-ID: <86802c440811031736l428d90a6we38c7a9c14288194@mail.gmail.com>
Date: Mon, 3 Nov 2008 17:36:01 -0800
From: "Yinghai Lu" <yinghai@kernel.org>
To: "=?ISO-8859-2?Q?Piotr_=A3obacz?=" <kocur666@gmail.com>
Subject: Re: latest kernel 2.6.27 and error message 'pci 0000:01:00.0: BAR 6: can't allocate mem resource [0xe0000000-0xdfffffff]'
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <14a58f0b0811031713x3cececb6x670a61eceffb8561@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Disposition: inline
References: <14a58f0b0811031713x3cececb6x670a61eceffb8561@mail.gmail.com>
X-Google-Sender-Auth: d1bd96f32a684b13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id mA41aPdq005221

On Mon, Nov 3, 2008 at 5:13 PM, Piotr £obacz <kocur666@gmail.com> wrote:> Hi all,> I have strange error message when I boot my linux with latest kerner> just like in the subject.>> I give you my /proc/iomem:> 00000000-0009f7ff : System RAM> 0009f800-0009ffff : reserved> 000a0000-000bffff : Video RAM area> 000c0000-000cdfff : Video ROM> 000ce000-000cf9ff : Adapter ROM> 000dc000-000fffff : reserved>  000f0000-000fffff : System ROM> 00100000-3fecffff : System RAM>  00100000-0048a7c2 : Kernel code>  0048a7c3-00595e97 : Kernel data>  005e4000-0062e767 : Kernel bss> 3fed0000-3fee2fff : ACPI Non-volatile Storage> 3fee3000-3fffffff : reserved> 50000000-500000ff : 0000:00:1f.3> c6000000-c7ffffff : PCI Bus 0000:06>  c6000000-c600ffff : 0000:06:00.0>    c6000000-c600ffff : tg3> c9000000-caffffff : PCI Bus 0000:01>  c9000000-c9ffffff : 0000:01:00.0>    c9000000-c9ffffff : nvidia>  ca000000-caffffff : 0000:01:00.0> cc000000-cdffffff : PCI Bus 0000:06> d0000000-dfffffff : PCI Bus 0000:01>  d0000000-dfffffff : 0000:01:00.0>    d0000000-d09fffff : uvesafb> e0000000-efffffff : PCI MMCONFIG 0>  e0000000-efffffff : reserved
that should be harmless... your BIOS have mmconf addr in BAR too, andthat BAR is read only, and BIOS should hide it to OS,
YHÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
