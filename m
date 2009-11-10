Return-Path: <linux-kernel-owner+w=401wt.eu-S1755739AbZKJCnE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755739AbZKJCnE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 21:43:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755097AbZKJCnD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 21:43:03 -0500
Received: from mail-gx0-f226.google.com ([209.85.217.226]:58137 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754831AbZKJCnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 21:43:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=mInCEjbTzQPFlV0cy14rJlHwZkyyqouGac7ah7ylq+Sthk7tPTDZLBmLecKW+coA+B
         f0oJD9PD9V3+oIXvkd/0L1m44L35oBeQGSByZGIh3eL+S/yeALAGm7FqqjQeBzZN//aH
         39ExOm6QZ2cyHZDk8tEpxvHChoCTlzPnRzN5U=
Subject: Re: [PATCH v7 17/17] tracing: make function graph tracer work with
 -mmcount-ra-address
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: David Daney <ddaney@caviumnetworks.com>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       zhangfx@lemote.com, zhouqg@gmail.com,
       Ralf Baechle <ralf@linux-mips.org>, rostedt@goodmis.org,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Nicholas Mc Guire <der.herr@hofr.at>,
       Richard Sandiford <rdsandiford@googlemail.com>,
       Patrik Kluba <kpajko79@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       Michal Simek <monstr@monstr.eu>
In-Reply-To: <4AF898E9.3050506@caviumnetworks.com>
References: <9dc81a7a9e5a292cccdf465c533a2b08d19d6021.1257779502.git.wuzhangjin@gmail.com>
	 <3a9fc9ca02e8e6e9c3c28797a4c084c1f9d91f69.1257779502.git.wuzhangjin@gmail.com>
	 <0cef783a71333ff96a78aaea8961e3b6b5392665.1257779502.git.wuzhangjin@gmail.com>
	 <18e1d617ed824bb1c10f15216f2ed9ed3de78abd.1257779502.git.wuzhangjin@gmail.com>
	 <3da916c1cb6e05445438826f98a91111f43ff6cd.1257779502.git.wuzhangjin@gmail.com>
	 <d4aa4cdb9b4c25e7a683c923bdeabed847bd8010.1257779502.git.wuzhangjin@gmail.com>
	 <451c55dead5d6afd871de6afd14dbbcf70a0f834.1257779502.git.wuzhangjin@gmail.com>
	 <0c463e2af521e613fd15751a9f610c74cf887292.1257779502.git.wuzhangjin@gmail.com>
	 <695747bff7cddb97d6f43c05c4cf05eb269e402d.1257779502.git.wuzhangjin@gmail.com>
	 <406a8e5e3117737e401bb2bba84ad9b17f99857d.1257779502.git.wuzhangjin@gmail.com>
	 <ceef672f082971118c472d1c079d49762ae43b38.1257779502.git.wuzhangjin@gmail.com>
	 <2113f5f0165feac8cf58c156946adff776f9056d.1257779502.git.wuzhangjin@gmail.com>
	 <4AF898E9.3050506@caviumnetworks.com>
Content-Type: text/plain; charset="UTF-8"
Organization: DSLab, Lanzhou University, China
Date: Tue, 10 Nov 2009 10:42:57 +0800
Message-ID: <1257820977.2822.32.camel@falcon.domain.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 2009-11-09 at 14:34 -0800, David Daney wrote:
> Wu Zhangjin wrote:
> [...]
> > +	cflags-y += $(call cc-option, -mmcount-ra-address)
> [...]
> > +#if (__GNUC__ <= 4 && __GNUC_MINOR__ < 5)
> 
> 
> 
> Sprinkling the code with these #if clauses is ugly and prone to breakage 
> I think.
> 
> The Makefile part is testing for the same feature.
> 
> We do a very similar thing with -msym32, and KBUILD_SYM32.  Perhaps you 
> could rework this patch in a similar manner and test for 
> KBUILD_MCOUNT_RA_ADDRESS instead of the '(__GNUC__ <= 4 && 
> __GNUC_MINOR__ < 5)'
> 

This is really ugly ;)

KBUILD_MCOUNT_RA_ADDRESS is a wonderful idea, thanks!

Regards,
	Wu Zhangjin

