Return-Path: <linux-kernel-owner+w=401wt.eu-S1753889AbZKPOaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889AbZKPOaR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 09:30:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752921AbZKPOaQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 09:30:16 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:38863 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763AbZKPOaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 09:30:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=juwn4LTvnpe/5S/viBQroegXW93ZpAruvrYkW4g8zF2SqPyiYuJ8+JYr6R+6xigC7k
         DPGQxGgqxz50HglpLsEhEh8RTY2vfkaY5ZzTEZvmXx9PpMwHNebif9/WmwqZJPZxHYny
         sQQk2luktsgjmt4iWcNUHFDpkYpo98iyZYzZQ=
Subject: Re: [PATCH v8 06/16] tracing: add an endian argument to
 scripts/recordmcount.pl
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: Thomas Gleixner <tglx@linutronix.de>
Cc: rostedt@goodmis.org, Ralf Baechle <ralf@linux-mips.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Nicholas Mc Guire <der.herr@hofr.at>,
       David Daney <ddaney@caviumnetworks.com>,
       Richard Sandiford <rdsandiford@googlemail.com>,
       Patrik Kluba <kpajko79@gmail.com>, Michal Simek <monstr@monstr.eu>,
       "Maciej W . Rozycki" <macro@linux-mips.org>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org, zhangfx@lemote.com, zhouqg@gmail.com
In-Reply-To: <alpine.LFD.2.00.0911161520080.24119@localhost.localdomain>
References: <9dc81a7a9e5a292cccdf465c533a2b08d19d6021.1258177321.git.wuzhangjin@gmail.com>
	 <b99c08397d9ff92ac5a72bda9131df41b702fc71.1258177321.git.wuzhangjin@gmail.com>
	 <8f579e2cece16cd22358a4ec143ef6a8c462639b.1258177321.git.wuzhangjin@gmail.com>
	 <ea337742d3ca7eec2825416041a6d4fa917d5cc4.1258177321.git.wuzhangjin@gmail.com>
	 <7c7568247ad6cc109ec20387cfc3ca258d1d430f.1258177321.git.wuzhangjin@gmail.com>
	 <3fcaffcfb3c8c8cd3015151ed5b7480ccaecde0f.1258177321.git.wuzhangjin@gmail.com>
	 <alpine.LFD.2.00.0911161520080.24119@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Organization: DSLab, Lanzhou University, China
Date: Mon, 16 Nov 2009 22:29:35 +0800
Message-ID: <1258381775.15821.1.camel@falcon.domain.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-16 at 15:21 +0100, Thomas Gleixner wrote:
> On Sat, 14 Nov 2009, Wu Zhangjin wrote:
> 
> > From: Wu Zhangjin <wuzhangjin@gmail.com>
> > 
> > MIPS and some other architectures need this argument to handle
> > big/little endian respectively.
> 
> Hmm, the patch adds the endian argument to the command line, but does
> nothing else with it. Is there something missing from the patch or is
> it just a left over from earlier iterations ?
> 

It is used in: 

[PATCH v8 07/16] tracing: add dynamic function tracer support for MIPS

Steven told me to split it out ;)

Thanks & Regards,
	Wu Zhangjin

