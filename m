Return-Path: <linux-kernel-owner+w=401wt.eu-S1754314AbZKKNaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754314AbZKKNaj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 08:30:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752602AbZKKNai
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 08:30:38 -0500
Received: from eddie.linux-mips.org ([78.24.191.182]:38781 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140AbZKKNai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 08:30:38 -0500
Date: Wed, 11 Nov 2009 13:30:40 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Ralf Baechle <ralf@linux-mips.org>
cc: Wu Zhangjin <wuzhangjin@gmail.com>,
       David Daney <ddaney@caviumnetworks.com>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org, zhangfx@lemote.com, zhouqg@gmail.com,
       rostedt@goodmis.org, Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Nicholas Mc Guire <der.herr@hofr.at>,
       Richard Sandiford <rdsandiford@googlemail.com>,
       Patrik Kluba <kpajko79@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       Michal Simek <monstr@monstr.eu>
Subject: Re: [PATCH v7 04/17] tracing: add static function tracer support
 for MIPS
In-Reply-To: <20091111031325.GA20716@linux-mips.org>
Message-ID: <alpine.LFD.2.00.0911111327450.10184@eddie.linux-mips.org>
References: <9dc81a7a9e5a292cccdf465c533a2b08d19d6021.1257779502.git.wuzhangjin@gmail.com> <b99c08397d9ff92ac5a72bda9131df41b702fc71.1257779502.git.wuzhangjin@gmail.com> <8f579e2cece16cd22358a4ec143ef6a8c462639b.1257779502.git.wuzhangjin@gmail.com>
 <cefe074f5eb3cfbc2e0bb41b0c1f61fcd0190d90.1257779502.git.wuzhangjin@gmail.com> <4AF8B31C.5030802@caviumnetworks.com> <1257814817.2822.3.camel@falcon.domain.org> <4AF99848.9090000@caviumnetworks.com> <1257907351.2922.37.camel@falcon.domain.org>
 <20091111031325.GA20716@linux-mips.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Nov 2009, Ralf Baechle wrote:

> 64-bit with -mlong-call:
> 
> 	lui	$25, %highest(foo)
> 	lui	$2, %hi(foo)
> 	daddiu	$25, %higher(foo)
> 	daddiu	$2, %lo(foo)
> 	dsll	$25, 32
> 	daddu	$25, $2
> 	jalr	$25

 Don't we use -msym32 these days for this very reason?

  Maciej
