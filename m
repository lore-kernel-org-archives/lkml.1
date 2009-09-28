Return-Path: <linux-kernel-owner+w=401wt.eu-S1752701AbZI1CVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701AbZI1CVj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 22:21:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752499AbZI1CVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 22:21:38 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61787 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752211AbZI1CVi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 22:21:38 -0400
Message-ID: <4AC01D6D.9070008@cn.fujitsu.com>
Date: Mon, 28 Sep 2009 10:20:29 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Masami Hiramatsu <mhiramat@redhat.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
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
Subject: Re: [RFC PATCH tracing/kprobes 2/5] tracing/kprobes: Avoid field
 name	confliction
References: <20090925191424.12939.91503.stgit@omoto> <20090925191505.12939.69682.stgit@omoto>
In-Reply-To: <20090925191505.12939.69682.stgit@omoto>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +/* Reserved field names */
> +#define FIELD_STRING_IP "ip"
> +#define FIELD_STRING_NARGS "nargs"
> +#define FIELD_STRING_RETIP "ret_ip"
> +#define FIELD_STRING_FUNC "func"
> +
> +const char *reserved_field_names[] = {
> +	"common_type",
> +	"common_flags",
> +	"common_preempt_count",
> +	"common_pid",
> +	"common_tgid",

There is a new common field "common_lock_depth"

> +	FIELD_STRING_IP,
> +	FIELD_STRING_NARGS,
> +	FIELD_STRING_RETIP,
> +	FIELD_STRING_FUNC,
> +};
