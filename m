Return-Path: <linux-kernel-owner+w=401wt.eu-S1752661AbZKLLGM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661AbZKLLGM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 06:06:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752479AbZKLLGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 06:06:11 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:65271 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431AbZKLLGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 06:06:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=iAcn9J5I7Iyx4FEZtfKu6hJoyzmTuku5ZKoFWZZ1IzvFzusiWJHBCdBHkU55nAuE/N
         VAtfBhCmAXm9LBqkBCIjqm2U8xx2pQME0LELfrjrRAG/s/beaJDablRMjBnGdTqrTqHU
         mn3gzo8G8r5b8CZT4d3gCXRlQXdgz2YxIPnS0=
Subject: Re: [PATCH v7 04/17] tracing: add static function tracer support
 for MIPS
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: linux-mips@linux-mips.org
Cc: linux-kernel@vger.kernel.org, zhangfx@lemote.com, zhouqg@gmail.com,
       Ralf Baechle <ralf@linux-mips.org>, rostedt@goodmis.org,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Nicholas Mc Guire <der.herr@hofr.at>,
       David Daney <ddaney@caviumnetworks.com>,
       Richard Sandiford <rdsandiford@googlemail.com>,
       Patrik Kluba <kpajko79@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       Michal Simek <monstr@monstr.eu>
In-Reply-To: <cefe074f5eb3cfbc2e0bb41b0c1f61fcd0190d90.1257779502.git.wuzhangjin@gmail.com>
References: <9dc81a7a9e5a292cccdf465c533a2b08d19d6021.1257779502.git.wuzhangjin@gmail.com>
	 <b99c08397d9ff92ac5a72bda9131df41b702fc71.1257779502.git.wuzhangjin@gmail.com>
	 <8f579e2cece16cd22358a4ec143ef6a8c462639b.1257779502.git.wuzhangjin@gmail.com>
	 <cefe074f5eb3cfbc2e0bb41b0c1f61fcd0190d90.1257779502.git.wuzhangjin@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: DSLab, Lanzhou University, China
Date: Thu, 12 Nov 2009 19:06:05 +0800
Message-ID: <1258023965.3113.79.camel@falcon.domain.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, All

On Mon, 2009-11-09 at 23:31 +0800, Wu Zhangjin wrote:
[...]
> 
> And to support module tracing, we need to enable -mlong-calls for the
> long call from modules space to kernel space. -mlong-calls load the
> address of _mcount to a register and then jump to it, so, the address is
> allowed to be 32bit long, but without -mlong-calls, for the instruction
> "jal _mcount" only left 26bit for the address of _mcount, which is not
> enough for jumping from the module space to kernel space.
[...]
> diff --git a/arch/mips/Makefile b/arch/mips/Makefile
[...]
> +else
> +cflags-y := -mlong-calls
> +endif

Just made dynamic ftracer work without the above patch.

Will send it out as v8 later.

any more feedbacks to this v7 patchset?

Thanks & Regards,
	Wu Zhangjin

