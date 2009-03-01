Return-Path: <linux-kernel-owner+w=401wt.eu-S1756520AbZCANQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756520AbZCANQ6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 08:16:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753065AbZCANQs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 08:16:48 -0500
Received: from crmm.lgl.lu ([158.64.72.228]:52578 "EHLO lll.lu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752662AbZCANQs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 08:16:48 -0500
Message-ID: <49AA8AA9.7080200@knaff.lu>
Date: Sun, 01 Mar 2009 14:16:25 +0100
From: Alain Knaff <alain@knaff.lu>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>
CC: Jan Engelhardt <jengelh@medozas.de>,
       the arch/x86 maintainers <x86@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: tip: bzip2/lzma now in tip:x86/setup-lzma
References: <200901042146.n04LkHgP005837@hitchhiker.hitchhiker.org.lu.hitchhiker.org.lu> <4961415C.1050708@zytor.com> <49614243.70102@knaff.lu> <496142E4.8040308@zytor.com> <49614491.7020903@knaff.lu> <49614D1F.8020900@zytor.com> <alpine.LSU.2.00.0902172202230.5620@fbirervta.pbzchgretzou.qr> <499B267E.2090509@zytor.com> <20090217220825.GA24337@elte.hu> <20090217233708.GA10756@elte.hu> <499B5BCA.8000905@zytor.com> <499BBD62.5090506@knaff.lu> <499DBCDD.90806@knaff.lu>
In-Reply-To: <499DBCDD.90806@knaff.lu>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alain Knaff wrote:
> Alain Knaff wrote:
>> hmmm, but on a second glance, there seems to be indeed an issue. When
>> compiling it a _second time_, compilation will "succeed" but produce a
>> bad kernel because the first attempt left an empty
>> usr/initramfs_data.cpio.bz2 .
>>
>> I'll look into it this evening, probably a case of "bad" failure
>> recovery in the Makefile.
>>
> 
> Took me slightly longer than promised, attached is the patch.
> 
> It changes/fixes three things:
> 1. Fix a bug in decompress.c : only scanned until the first
> non-configured compressor (with disastrous result if that was gzip)
> 2. Fix a bug in gen_initramfs_list.sh : in case of failure, it left
> indeed an empty output file behind, messing up the next make.
> 3. Make builtin initramfs compression configurable
> 
> Regards,
> 
> Alain
> 

Any comments about this? Ingo, does it solve the issue with randconfig?

Btw, when will the next merge-window be, so that I can plan ahead to be
available enough?

Thanks,

Alain

