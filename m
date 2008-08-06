Return-Path: <linux-kernel-owner+w=401wt.eu-S1765601AbYHFI4y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765601AbYHFI4y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 04:56:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764921AbYHFItZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 04:49:25 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:3391 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764911AbYHFItY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 04:49:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=fLysQRZqBrU0Gqi4Y7dELaFoZ5fersQXHPHvB+8o3yOzg5QiWlC3Ks06HkyxqlFhl3
         K/gn2BiHYEiqboCLNDclDExpNx0up76EZEm7pkChAp748v4CgxL2fVe87uRklX3qq8Eo
         KLzun3JVidlf0+FBxFG0z/1NSlDiSbIDQpW5c=
Message-ID: <86802c440808060149s697fe9p43f0be72d464f75e@mail.gmail.com>
Date: Wed, 6 Aug 2008 01:49:22 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Jeff Chua" <jeff.chua.linux@gmail.com>
Subject: Re: 2.6.27rc1 cannot boot more than 8CPUs
Cc: "David Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
In-Reply-To: <b6a2187b0808052342w6fba9152m197d56aa9e88746a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b6a2187b0808052015g698430fah95b5dc2c25dc396a@mail.gmail.com>
	 <20080805.221917.42858161.davem@davemloft.net>
	 <b6a2187b0808052342w6fba9152m197d56aa9e88746a@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 5, 2008 at 11:42 PM, Jeff Chua <jeff.chua.linux@gmail.com> wrote:
> On Wed, Aug 6, 2008 at 1:19 PM, David Miller <davem@davemloft.net> wrote:
>> From: "Jeff Chua" <jeff.chua.linux@gmail.com>
>> Date: Wed, 6 Aug 2008 11:15:30 +0800
>> Do you have lockdep enabled?  If sure, try turning that off.
>
> It's enabled by default, and I can't seem to disable it even if I
> commented it out or delete it, it comes back after running "make".
>
> CONFIG_X86_32=y
> # CONFIG_X86_64 is not set
> CONFIG_X86=y
> CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
> # CONFIG_GENERIC_LOCKBREAK is not set
> CONFIG_GENERIC_TIME=y
> CONFIG_GENERIC_CMOS_UPDATE=y
> CONFIG_CLOCKSOURCE_WATCHDOG=y
> CONFIG_GENERIC_CLOCKEVENTS=y
> CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
> CONFIG_LOCKDEP_SUPPORT=y
> CONFIG_STACKTRACE_SUPPORT=y
> CONFIG_HAVE_LATENCYTOP_SUPPORT=y
> CONFIG_FAST_CMPXCHG_LOCAL=y
> CONFIG_MMU=y
> CONFIG_ZONE_DMA=y
> CONFIG_GENERIC_ISA_DMA=y
> CONFIG_GENERIC_IOMAP=y
> CONFIG_GENERIC_BUG=y
> CONFIG_GENERIC_HWEIGHT=y
>
>

do you have

CONFIG_X86_GENERICARCH=y
CONFIG_X86_BIGSMP=y

8 more cpu need bigsmp mode.

YH
