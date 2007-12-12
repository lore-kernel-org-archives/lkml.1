Return-Path: <linux-kernel-owner+w=401wt.eu-S1758356AbXLLIiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758356AbXLLIiu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 03:38:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753648AbXLLIim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 03:38:42 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:26595 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465AbXLLIim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 03:38:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qqwi9iKPVwnii3SZ4SBqfi2hQo+3B9aUkzx5VQRytgnryAi6CP8R9Cg5JjPMHKha90KjnrvSNMbXSeq2Z3UVm6rimPR9EsRMIm9hTO3vHwrcRMw7SByXvCPVf3SI1lwi5ERbeMmHNtfA/pRKSLRJxZMLSuL6G81lyGYdXU3nnak=
Message-ID: <47847f440712120038i4133b630l142376728614a4e7@mail.gmail.com>
Date: Wed, 12 Dec 2007 09:38:41 +0100
From: "=?ISO-8859-1?Q?Edwin_de_Caluw=E9?=" <edwindecaluwe@gmail.com>
To: "Paolo Ornati" <ornati@fastwebnet.it>
Subject: Re: [RFT] Port 0x80 I/O speed
Cc: "Rene Herman" <rene.herman@gmail.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>, dpreed@reed.com,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>, pavel@ucw.cz,
       andi@firstfloor.org, rol@as2917.net, "Krzysztof Halasa" <khc@pm.waw.pl>,
       david@davidnewall.com, hpa@zytor.com, john@stoffel.org,
       linux-os@analogic.com
In-Reply-To: <20071212091715.7f89fd22@fastwebnet.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <475F1DC6.5090403@keyaccess.nl>
	 <20071212091715.7f89fd22@fastwebnet.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Exactly constant timing in every iteration:

cycles: out 667, in 305

processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 8
model name      : Celeron (Coppermine)
stepping        : 3
cpu MHz         : 497.582
cache size      : 128 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 sep mtrr pge mca
cmov pat pse36 mmx fxsr sse up
bogomips        : 996.21
clflush size    : 32


On 12/12/07, Paolo Ornati <ornati@fastwebnet.it> wrote:
> On Wed, 12 Dec 2007 00:31:18 +0100
> Rene Herman <rene.herman@gmail.com> wrote:
> >
> > and on a PII 400 (Intel 440BX chipset) a constant:
> >
> > rene@6bap:~/src/port80$ su -c ./port80
> > cycles: out 553, in 251
> >
> > Results are (mostly) independent of compiler optimisation, but testing
> with
> > an -O2 compile should be most useful. Thanks!
> >
>
> ### Core2 Duo 1.8 GHz ###
>
> X86_64 -m32 -O2:
>
> $ for i in `seq 5`; do sudo ./port80; sleep 1; done
> cycles: out 1498, in 964
> cycles: out 1498, in 964
> cycles: out 1499, in 964
> cycles: out 1498, in 964
> cycles: out 1498, in 965
>
> processor	: 0
> vendor_id	: GenuineIntel
> cpu family	: 6
> model		: 15
> model name	: Intel(R) Core(TM)2 CPU          6300  @ 1.86GHz
> stepping	: 6
> cpu MHz		: 1864.805
> cache size	: 2048 KB
> physical id	: 0
> siblings	: 2
> core id		: 0
> cpu cores	: 2
> fpu		: yes
> fpu_exception	: yes
> cpuid level	: 10
> wp		: yes
> flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat
> pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm
> constant_tsc arch_perfmon pebs bts rep_good pni monitor ds_cpl vmx est tm2
> ssse3 cx16 xtpr lahf_lm
> bogomips	: 3731.82
> clflush size	: 64
> cache_alignment	: 64
> address sizes	: 36 bits physical, 48 bits virtual
> power management:
>
> [...]
>
>
> --
> 	Paolo Ornati
> 	Linux 2.6.24-rc4-g94545bad on x86_64
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
