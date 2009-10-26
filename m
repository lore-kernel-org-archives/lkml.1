Return-Path: <linux-kernel-owner+w=401wt.eu-S1752376AbZJZOBF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752376AbZJZOBF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 10:01:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752269AbZJZOBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 10:01:05 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:53403 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264AbZJZOBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 10:01:04 -0400
Subject: Re: [PATCH -v5 02/11] MIPS: add mips_timecounter_read() to get
 high precision timestamp
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Wu Zhangjin <wuzhangjin@gmail.com>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Ralf Baechle <ralf@linux-mips.org>,
       Nicholas Mc Guire <der.herr@hofr.at>,
       Richard Sandiford <rdsandiford@googlemail.com>,
       David Daney <ddaney@caviumnetworks.com>,
       Adam Nemet <anemet@caviumnetworks.com>,
       Patrik Kluba <kpajko79@gmail.com>
In-Reply-To: <2f73eae542c47ac5bbb9f7280e6c0271d193e90d.1256483735.git.wuzhangjin@gmail.com>
References: <cover.1256482555.git.wuzhangjin@gmail.com>
	 <028867b99ec532b84963a35e7d552becc783cafc.1256483735.git.wuzhangjin@gmail.com>
	 <2f73eae542c47ac5bbb9f7280e6c0271d193e90d.1256483735.git.wuzhangjin@gmail.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Mon, 26 Oct 2009 10:01:07 -0400
Message-Id: <1256565667.26028.257.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-10-25 at 23:16 +0800, Wu Zhangjin wrote:
> This patch implement a mips_timecounter_read(), which can be used to get
> high precision timestamp without extra lock.
> 
> It is based on the clock counter register and the
> timecounter/cyclecounter abstraction layer of kernel.
> 
> Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>
> ---
>  arch/mips/include/asm/time.h |   19 +++++++++++++++++++
>  arch/mips/kernel/csrc-r4k.c  |   41 +++++++++++++++++++++++++++++++++++++++++
>  arch/mips/kernel/time.c      |    2 ++

Some patches touch core tracing code, and some are arch specific. Now
the question is how do we go. I prefer that we go the path of the
tracing tree (easier for me to test). But every patch that touches MIPS
arch, needs an Acked-by from the MIPS maintainer. Which I see is Ralf
(on the Cc of this patch set.)

Thanks,

-- Steve


