Return-Path: <linux-kernel-owner+w=401wt.eu-S1753937AbZJZAmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937AbZJZAmr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 20:42:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751498AbZJZAmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 20:42:46 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:53750 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbZJZAmp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 20:42:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Go6Z2AH26fE+XRbK9QCShYidFdl3crhnKrTRm3QvVCJ47ghqt7qa3z+JAwnbmwASVi
         4AbLFxDveNdQ7fTnrRKI/9d4Z9RX5SKVgAOD0KTN7nozuLjAeeMfdV7W6imcD+JLCkDZ
         5BrxcNpHo/4i6fp7kALSexkhwjC/eWsWaejRA=
MIME-Version: 1.0
In-Reply-To: <cover.1256482555.git.wuzhangjin@gmail.com>
References: <cover.1256482555.git.wuzhangjin@gmail.com>
Date: Mon, 26 Oct 2009 01:42:49 +0100
Message-ID: <c62985530910251742n77dea8acgc00baf6a4075ee8d@mail.gmail.com>
Subject: Re: [PATCH -v5 00/11] ftrace for MIPS
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Wu Zhangjin <wuzhangjin@gmail.com>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, Thomas Gleixner <tglx@linutronix.de>,
       Ralf Baechle <ralf@linux-mips.org>,
       Nicholas Mc Guire <der.herr@hofr.at>,
       Richard Sandiford <rdsandiford@googlemail.com>,
       David Daney <ddaney@caviumnetworks.com>,
       Adam Nemet <anemet@caviumnetworks.com>,
       Patrik Kluba <kpajko79@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/10/25 Wu Zhangjin <wuzhangjin@gmail.com>:
> Under the help of the -mlong-calls option of gcc, This revision comes with the
> module tracing support. and there are also lots of cleanups and fixes.
> therefore, it is ready to upstream.
>
> Currently, function graph tracer support have some overhead for searching the
> stack address of the return address(ra). we hope the PROFILE_BEFORE_PROLOGUE
> macro will be enabled by default in the next version of gcc, and then the
> overhead can be removed via hijacking the ra register directly for both
> non-leaf and leaf function.
>
> Thanks very much to the people in the CC list for their feedbacks, all the
> lastest changes goes to this git repo:
>
> git://dev.lemote.com/rt4ls.git  linux-mips/dev/ftrace-upstream
>
> Welcome to play with it and give more feedbacks.
>
> Thanks & Regards,
>       Wu Zhangjin
>
> Wu Zhangjin (11):
>  tracing: convert trace_clock_local() as weak function
>  MIPS: add mips_timecounter_read() to get high precision timestamp
>  tracing: add MIPS specific trace_clock_local()
>  tracing: add static function tracer support for MIPS
>  tracing: enable HAVE_FUNCTION_TRACE_MCOUNT_TEST for MIPS
>  tracing: add an endian argument to scripts/recordmcount.pl
>  tracing: add dynamic function tracer support for MIPS
>  tracing: not trace mips_timecounter_init() in MIPS
>  tracing: add IRQENTRY_EXIT for MIPS
>  tracing: add function graph tracer support for MIPS


I can't find this one in the series. Did you forget it or am I somehow
missing it?

Thanks.
