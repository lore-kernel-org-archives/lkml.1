Return-Path: <linux-kernel-owner+w=401wt.eu-S1757865AbZJLS5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757865AbZJLS5W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 14:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753494AbZJLS5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 14:57:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64100 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752958AbZJLS5U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 14:57:20 -0400
Message-ID: <4AD37CB0.8060302@redhat.com>
Date: Mon, 12 Oct 2009 15:00:00 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [PATCH tracing/kprobes v4] perf: Add perf probe subcommand for
 kprobe-event setup helper
References: <4ACE56EE.8060000@redhat.com> <20091008211737.29299.14784.stgit@dhcp-100-2-132.bos.redhat.com> <20091012180751.GD5059@nowhere>
In-Reply-To: <20091012180751.GD5059@nowhere>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Thu, Oct 08, 2009 at 05:17:38PM -0400, Masami Hiramatsu wrote:
>> +#ifdef DEBUG
>> +#define debug(fmt ...)	\
>> +	fprintf(stderr, "DBG(" __FILE__ ":" stringify(__LINE__) "): " fmt)
>> +#else
>> +#define debug(fmt ...)	do {} while (0)
>> +#endif
>
>
>
> We have that too:
>
> int eprintf(const char *fmt, ...) __attribute__((format(printf, 1, 2)));
> int dump_printf(const char *fmt, ...) __attribute__((format(printf, 1, 2)));

Thanks, I'll use that.

>> +#define ERR_IF(cnd)	\
>> +	do { if (cnd) {	\
>> +		fprintf(stderr, "Error (" __FILE__ ":" stringify(__LINE__) \
>> +			"): " stringify(cnd) "\n");			\
>> +		exit(1);						\
>> +	} } while (0)
>
>
> And that would be nice to have in util/debug.h but more
> perhaps more as a DIE_IF()
>

Sure :-)

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

