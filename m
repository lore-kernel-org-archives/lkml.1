Return-Path: <linux-kernel-owner+w=401wt.eu-S1755511AbZKDLSp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511AbZKDLSp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 06:18:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755470AbZKDLSo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 06:18:44 -0500
Received: from mail-pz0-f188.google.com ([209.85.222.188]:61912 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755167AbZKDLSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 06:18:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=bWkwf5R9qWDLJZJZME5btonNRxjMnSGTUxnPhlq/EOfwuP/jW+TGk5CtbUfps9cj3G
         H9U23Q2ui0YwaqZPyeOuMgRsmzkf3FVSiOUv5xMT9TzF5yKiouTuV/zfXJpbS/39PZ8y
         lYS5UKObIKwNTCP9quNS+dewke05PQNHMfo24=
Subject: Re: [PATCH -queue v0 5/6] [loongson] rtc: enable legacy RTC driver
 on fuloong2f
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: Arnaud Patard <apatard@mandriva.com>
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
       LKML <linux-kernel@vger.kernel.org>, huhb@lemote.com, yanh@lemote.com,
       Zhang Le <r0bertz@gentoo.org>, Thomas Gleixner <tglx@linutronix.de>,
       Nicholas Mc Guire <der.herr@hofr.at>, zhangfx@lemote.com,
       liujl@lemote.com
In-Reply-To: <m3eioetvx5.fsf@anduin.mandriva.com>
References: <cover.1257325319.git.wuzhangjin@gmail.com>
	 <e13ed33a99dbf14f223360d414aa2b2c5caa9b1f.1257325319.git.wuzhangjin@gmail.com>
	 <m3eioetvx5.fsf@anduin.mandriva.com>
Content-Type: text/plain; charset="UTF-8"
Organization: DSLab, Lanzhou University, China
Date: Wed, 04 Nov 2009 19:18:47 +0800
Message-ID: <1257333527.8716.20.camel@falcon.domain.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 2009-11-04 at 11:40 +0100, Arnaud Patard wrote:
> Wu Zhangjin <wuzhangjin@gmail.com> writes:
> 
> Hi,
> 
> > RTC_LIB is selected by MIPS by default, and therefore, the legacy RTC driver is
> > disabled. but unfortunately, RTC_LIB not works on fulong, so, enabling the legcy
> > RTC driver is needed, otherwise, the tools like hwclock will not work.
> >
> > because loongson family machines, including fuloong2e, fuloong2f and
> > yeeloong2f need to enable legacy RTC driver, so we use MACH_LOONGSON
> > here.
> 
> There are loongson machines which are working fine with RTC_LIB (for
> instance the gdium which is using a m41t83 on i2c) so would be better to
> be more restrictive imho.

In reality, fuloong2e, fuloong2f and yeeloong2f work fine with RTC_LIB,
but relative patches need to append to drivers/rtc/rtc-cmos.c and also
need a RTC platform device. If what I remembered is right, Gdium also
need corresponding patches to make it work with RTC_LIB.

Herein, I just let the basic support for those machines work, and then,
the RTC_LIB support will be sent out later.

and a small question: if legacy RTC driver works well on these machines,
why should we forbid people to use it? I think it's better to remove the
"select RTC_LIB" line for MIPS, and then, the people will be free to
choose what they want, and even for the users whose platform not support
RTC_LIB.

Regards,
	Wu Zhangjin

