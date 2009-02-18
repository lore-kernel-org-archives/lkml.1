Return-Path: <linux-kernel-owner+w=401wt.eu-S1754351AbZBRTxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351AbZBRTxY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 14:53:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751425AbZBRTxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 14:53:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43592 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbZBRTxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 14:53:14 -0500
Message-ID: <499C670F.9090203@zytor.com>
Date: Wed, 18 Feb 2009 11:52:47 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Alain Knaff <alain@knaff.lu>
CC: Ingo Molnar <mingo@elte.hu>, Jan Engelhardt <jengelh@medozas.de>,
       the arch/x86 maintainers <x86@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: tip: bzip2/lzma now in tip:x86/setup-lzma
References: <200901042146.n04LkHgP005837@hitchhiker.hitchhiker.org.lu.hitchhiker.org.lu> <4961415C.1050708@zytor.com> <49614243.70102@knaff.lu> <496142E4.8040308@zytor.com> <49614491.7020903@knaff.lu> <49614D1F.8020900@zytor.com> <alpine.LSU.2.00.0902172202230.5620@fbirervta.pbzchgretzou.qr> <499B267E.2090509@zytor.com> <20090217220825.GA24337@elte.hu> <20090217233708.GA10756@elte.hu> <499B5BCA.8000905@zytor.com> <499BBD62.5090506@knaff.lu>
In-Reply-To: <499BBD62.5090506@knaff.lu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alain Knaff wrote:
> 
> Maybe another solution would be to make the choice of builtin ramdisk
> compression user-selectable, and default to no compression at all.
> 

That might just make most sense.

> Indeed, in the default case, the builtin ramdisk is so small (950 bytes
> uncompressed), that it probably wouldn't really matter anyways.
> 
> The only case where it matters is for developers of embedded systems who
> want to replace the builtin ramdisk with a fully populated one, because
> their boot loader does not support loading a "normal" initrd.
> 
> These people are (hopefully) knowledgeable enough to pick an appropriate
> compressor (but there's still the issue of notifying them about the
> change, obviously).
> 
> Btw, what *is* the standard work flow of supplying your own built-in
> initramfs? Do such developers usually supply a directory tree, or do
> they already cpio it before supplying it to the kernel? Or do they even
> compress it themselves?

The normal thing is that you point the kernel build to an 
out-of-the-kernel-build-tree directory.

	-hpa

