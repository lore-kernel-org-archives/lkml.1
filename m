Return-Path: <linux-kernel-owner+w=401wt.eu-S1757374AbYH2QR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757374AbYH2QR3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 12:17:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753262AbYH2QRV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 12:17:21 -0400
Received: from ortiz.unizar.es ([155.210.1.52]:56870 "EHLO ortiz.unizar.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753186AbYH2QRV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 12:17:21 -0400
Message-Id: <8EF35F63-8FF6-483F-9DED-D573C40430C8@ono.com>
From: "=?ISO-8859-1?Q?=22J.A._Magall=F3n=22?=" <jamagallon@ono.com>
To: Linux-Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20080829090139.30c69ead@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed; delsp=yes
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: Out of mtrrs
Date: Fri, 29 Aug 2008 18:17:18 +0200
References: <BEE3259F-0ED8-4030-9CA5-D8892C9096C2@ono.com> <20080829090139.30c69ead@infradead.org>
X-Mailer: Apple Mail (2.926)
X-Mail-Scanned: Criba 2.0 + Clamd & Bogofilter
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 2008.08.29, at 18:01, Arjan van de Ven wrote:

> On Fri, 29 Aug 2008 17:32:49 +0200
> ""J.A. Magallón"" <jamagallon@ono.com> wrote:
>
>> Hi all...
>>
>> I'm using the xorg intel driver, and drm/X report it has no free  
>> mtrrs
>> in kernel to set up:
>>
>> one:~# cat /proc/mtrr
>> reg00: base=0xfffe0000 (4095MB), size= 128KB: write-protect, count=1
>> reg01: base=0xfffc0000 (4095MB), size= 128KB: uncachable, count=1
>> reg02: base=0x00000000 (   0MB), size= 256MB: write-back, count=1
>> reg03: base=0x10000000 ( 256MB), size= 256MB: write-back, count=1
>> reg04: base=0x1f800000 ( 504MB), size=   8MB: uncachable, count=1
>> reg05: base=0x1f600000 ( 502MB), size=   2MB: uncachable, count=1
>> reg06: base=0x1f500000 ( 501MB), size=   1MB: uncachable, count=1
>> reg07: base=0x00000000 (   0MB), size= 128KB: uncachable, count=1
>>

with disable_mtrr_trim, I get te same:

reg00: base=0xfffe0000 (4095MB), size= 128KB: write-protect, count=1
reg01: base=0xfffc0000 (4095MB), size= 128KB: uncachable, count=1
reg02: base=0x00000000 (   0MB), size= 256MB: write-back, count=1
reg03: base=0x10000000 ( 256MB), size= 256MB: write-back, count=1
reg04: base=0x1f800000 ( 504MB), size=   8MB: uncachable, count=1
reg05: base=0x1f600000 ( 502MB), size=   2MB: uncachable, count=1
reg06: base=0x1f500000 ( 501MB), size=   1MB: uncachable, count=1
reg07: base=0x00000000 (   0MB), size= 128KB: uncachable, count=1

Is there any other option ?

cicely:/usr/share/doc/kernel-doc# grep mtrr kernel-par*
	disable_mtrr_trim [X86, Intel and AMD only]

> did this work with older kernels?
> if so, you should disable the MTRR munging feature of newer kernels;
> it's not working well enough ;)

--
J.A. Magallon <jamagallon()ono!com>     \               Software is  
like sex:
                                          \         It's better when  
it's free
Mandriva Linux release 2009.0 (Cooker) for i586
Linux 2.6.25-jam13 (gcc 4.3.1 20080515 (GCC) #1 SMP



