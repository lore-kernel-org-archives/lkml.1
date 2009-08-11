Return-Path: <linux-kernel-owner+w=401wt.eu-S1754701AbZHKNvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701AbZHKNvq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 09:51:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754019AbZHKNvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 09:51:46 -0400
Received: from co203.xi-lite.net ([149.6.83.203]:50535 "EHLO co203.xi-lite.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753911AbZHKNvp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 09:51:45 -0400
Message-ID: <4A81776E.8080104@parrot.com>
Date: Tue, 11 Aug 2009 15:51:42 +0200
From: Matthieu CASTET <matthieu.castet@parrot.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: Albin Tonnerre <albin.tonnerre@free-electrons.com>
CC: Sam Ravnborg <sam@ravnborg.org>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Alain Knaff <alain@knaff.lu>, "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-embedded@vger.kernel.org" <linux-embedded@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/6] Add support for LZO-compressed kernels for ARM
References: <20090806224055.GH31579@n2100.arm.linux.org.uk> <20090807092423.GA4455@laptop> <4A7BF5B8.4030907@knaff.lu> <20090807102117.GB4455@laptop> <4A7C14EB.1060701@parrot.com> <20090807130130.GE4455@laptop> <4A7C2BA4.7030408@parrot.com> <20090807135524.GF4455@laptop> <20090807200001.GE31543@n2100.arm.linux.org.uk> <20090807210816.GA29797@merkur.ravnborg.org> <20090811094418.GI9704@pc-ras4041.res.insa>
In-Reply-To: <20090811094418.GI9704@pc-ras4041.res.insa>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Albin Tonnerre a écrit :
> Hi Sam,
> 
> On Fri, Aug 07, 2009 at 11:08:16PM +0200, Sam Ravnborg wrote :
>> We could add libgcc as a prerequisite.
>> Untested patch below.
> 
> When compiling with this patch applied, I get the following error:
> 
>   Kernel: arch/arm/boot/Image is ready
>     LD      arch/arm/boot/compressed/vmlinux
> /home/albin/x-tools/arm-unknown-linux-uclibcgnueabi/lib/gcc/arm-unknown-linux-uclibcgnueabi/4.3.2/libgcc.a(_dvmd_lnx.o):
> In function `__div0':
> /home/albin/devel/free-electrons/toolchain/targets/src/gcc-4.3.2/libgcc/../gcc/config/arm/lib1funcs.asm:1079:
> undefined reference to `raise'
> make[2]: *** [arch/arm/boot/compressed/vmlinux] Error 1
> make[1]: *** [arch/arm/boot/compressed/vmlinux] Error 2
> 
> I've got no idea where this symbol is defined, though. Has anyone an idea on
> this ?
It is defined in libc ;)
You need either to provide a fake one, or use don't use libgcc.

Matthieu

