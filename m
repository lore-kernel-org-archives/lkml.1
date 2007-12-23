Return-Path: <linux-kernel-owner+w=401wt.eu-S1756383AbXLWSWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756383AbXLWSWY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 13:22:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753851AbXLWSWP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 13:22:15 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:65370 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753684AbXLWSWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 13:22:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CLo4Ki64M1JomDp8m4J4hUji2rmcGAXyDJtzk/FK/wlsqHbuwMTdcykhaSLTKGKWKE3pLUNa0+DmvFe+wagYlTjVCCh0CThbY9YreGd/TSUpCtRsIO7wF96YE8OOXPwb1vlLblD3Z+PsfY1/YcRyvIYCYoephekDdGYCc8GVylQ=
Message-ID: <9e0cf0bf0712231022o4a282e70i8cecd70ecc452505@mail.gmail.com>
Date: Sun, 23 Dec 2007 20:22:13 +0200
From: "Alon Bar-Lev" <alon.barlev@gmail.com>
To: linux-mips@ftp.linux-mips.org, LKML <linux-kernel@vger.kernel.org>,
       ppopov@mvista.com
Subject: Re: [MIPS] MEM_SDREFCFG is not defined for Alchemy DB1550 (compile fail)
In-Reply-To: <9e0cf0bf0712230733o3dfd54fcp4962ebf3f84cdff@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9e0cf0bf0712230733o3dfd54fcp4962ebf3f84cdff@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Forgot to write that I checked mips & linus gits, and the problem still exists.

Best Regards,
Alon Bar-Lev.

On 12/23/07, Alon Bar-Lev <alon.barlev@gmail.com> wrote:
> Hello,
>
> When I have:
> CONFIG_MIPS_DB1550
> CONFIG_SOC_AU1550
> CONFIG_SOC_AU1X00
> CONFIG_PM
>
> MEM_SDREFCFG is used at:
> arch/mips/au1000/common/power.c::pm_do_freq()
>
> While the MEM_SDREFCFG constant is declare only for CONFIG_SOC_AU1000,
> CONFIG_SOC_AU1500, CONFIG_SOC_AU1100 at:
> include/asm-mips/mach-au1x00/au1000.h
>
> Maybe MEM_SDREFCFG should be defined for CONFIG_SOC_AU1X00?
> Or there should be #ifdef for its usage in power.c?
>
> Best Regards,
> Alon Bar-Lev.
>
