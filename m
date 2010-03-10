Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755778Ab0CJNMf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 08:12:35 -0500
Received: from mail-ww0-f46.google.com ([74.125.82.46]:53949 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755335Ab0CJNMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 08:12:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=aep6cxsUYaryK4bdUh92TjGeHKkXWhIFydNqS7l7egjW302Efg2pI2HjBlIP66jDIg
         81VmabKJtSv35tH2R4huROTkkLnVt2wMW9TeYM8ZobKJC0g+BkMnc8G66lSuztnDpuYm
         yTsaPVSFI8curVuzZwE5rpgkQsh/RV4a17QVE=
MIME-Version: 1.0
In-Reply-To: <20100310120155.GO24422@rakim.wolfsonmicro.main>
References: <alpine.DEB.2.00.0912152157330.27772@ayla.of.borg>
	 <20091215221357.GA26024@opensource.wolfsonmicro.com>
	 <10f740e81003091113j5b55edf7r7eec8728bcc87821@mail.gmail.com>
	 <20100310120155.GO24422@rakim.wolfsonmicro.main>
Date: Wed, 10 Mar 2010 14:12:30 +0100
X-Google-Sender-Auth: 3ea46827ab389c88
Message-ID: <10f740e81003100512u6d3430cy339cc4f833dafbb5@mail.gmail.com>
Subject: Re: [PATCH] mfd: MFD_WM831X should depend on GENERIC_HARDIRQS
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>,
       Samuel Ortiz <sameo@linux.intel.com>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 10, 2010 at 13:01, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Tue, Mar 09, 2010 at 08:13:56PM +0100, Geert Uytterhoeven wrote:
>
>> > Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
>
>> This patch still hasn't made it. In addition, 3 more drivers started
>> to show the same problems
>> on architectures that don't use genirq yet, so I updated it.
>
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
>
> TBH I'm surprised there's architectures that haven't implemented genirq
> yet.

There still are: m68k, s390, and sparc32. Converting m68k is on my
(too long) list...

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
