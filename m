Return-Path: <linux-kernel-owner+w=401wt.eu-S1755228AbZKDKkW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228AbZKDKkW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 05:40:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755141AbZKDKkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 05:40:21 -0500
Received: from mx1.moondrake.net ([212.85.150.166]:49228 "EHLO
	mx1.mandriva.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754775AbZKDKkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 05:40:20 -0500
X-Spam-Virus: No
From: Arnaud Patard <apatard@mandriva.com>
To: Wu Zhangjin <wuzhangjin@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
       LKML <linux-kernel@vger.kernel.org>, huhb@lemote.com, yanh@lemote.com,
       Zhang Le <r0bertz@gentoo.org>, Thomas Gleixner <tglx@linutronix.de>,
       Nicholas Mc Guire <der.herr@hofr.at>, zhangfx@lemote.com,
       liujl@lemote.com
Subject: Re: [PATCH -queue v0 5/6] [loongson] rtc: enable legacy RTC driver on fuloong2f
References: <cover.1257325319.git.wuzhangjin@gmail.com>
	<e13ed33a99dbf14f223360d414aa2b2c5caa9b1f.1257325319.git.wuzhangjin@gmail.com>
Organization: Mandriva
Date: Wed, 04 Nov 2009 11:40:38 +0100
In-Reply-To: <e13ed33a99dbf14f223360d414aa2b2c5caa9b1f.1257325319.git.wuzhangjin@gmail.com> (Wu Zhangjin's message of "Wed,  4 Nov 2009 17:06:07 +0800")
Message-ID: <m3eioetvx5.fsf@anduin.mandriva.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wu Zhangjin <wuzhangjin@gmail.com> writes:

Hi,

> RTC_LIB is selected by MIPS by default, and therefore, the legacy RTC driver is
> disabled. but fortunately, RTC_LIB not works on fulong, so, enabling the legcy
> RTC driver is needed, otherwise, the tools like hwclock will not work.
>
> because loongson family machines, including fuloong2e, fuloong2f and
> yeeloong2f need to enable legacy RTC driver, so we use MACH_LOONGSON
> here.

There are loongson machines which are working fine with RTC_LIB (for
instance the gdium which is using a m41t83 on i2c) so would be better to
be more restrictive imho.

Arnaud
