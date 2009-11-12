Return-Path: <linux-kernel-owner+w=401wt.eu-S1754556AbZKLVQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556AbZKLVQx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 16:16:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754401AbZKLVQs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 16:16:48 -0500
Received: from eddie.linux-mips.org ([78.24.191.182]:54152 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754252AbZKLVQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 16:16:47 -0500
Date: Thu, 12 Nov 2009 22:16:37 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Wu Zhangjin <wuzhangjin@gmail.com>,
       David Daney <ddaney@caviumnetworks.com>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org, zhangfx@lemote.com, zhouqg@gmail.com,
       rostedt@goodmis.org, Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Nicholas Mc Guire <der.herr@hofr.at>,
       Richard Sandiford <rdsandiford@googlemail.com>,
       Patrik Kluba <kpajko79@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       Michal Simek <monstr@monstr.eu>
Subject: Re: [PATCH v7 04/17] tracing: add static function tracer support
	for MIPS
Message-ID: <20091112211637.GA27465@linux-mips.org>
References: <9dc81a7a9e5a292cccdf465c533a2b08d19d6021.1257779502.git.wuzhangjin@gmail.com> <b99c08397d9ff92ac5a72bda9131df41b702fc71.1257779502.git.wuzhangjin@gmail.com> <8f579e2cece16cd22358a4ec143ef6a8c462639b.1257779502.git.wuzhangjin@gmail.com> <cefe074f5eb3cfbc2e0bb41b0c1f61fcd0190d90.1257779502.git.wuzhangjin@gmail.com> <4AF8B31C.5030802@caviumnetworks.com> <1257814817.2822.3.camel@falcon.domain.org> <4AF99848.9090000@caviumnetworks.com> <1257907351.2922.37.camel@falcon.domain.org> <20091111031325.GA20716@linux-mips.org> <alpine.LFD.2.00.0911111327450.10184@eddie.linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0911111327450.10184@eddie.linux-mips.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 11, 2009 at 01:30:40PM +0000, Maciej W. Rozycki wrote:

> 
> On Wed, 11 Nov 2009, Ralf Baechle wrote:
> 
> > 64-bit with -mlong-call:
> > 
> > 	lui	$25, %highest(foo)
> > 	lui	$2, %hi(foo)
> > 	daddiu	$25, %higher(foo)
> > 	daddiu	$2, %lo(foo)
> > 	dsll	$25, 32
> > 	daddu	$25, $2
> > 	jalr	$25
> 
>  Don't we use -msym32 these days for this very reason?

We do - where we can.  Not all systems can use -msym32.

  Ralf
