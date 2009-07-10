Return-Path: <linux-kernel-owner+w=401wt.eu-S1752624AbZGJFRu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624AbZGJFRu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 01:17:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751152AbZGJFRn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 01:17:43 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56308 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750885AbZGJFRm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 01:17:42 -0400
Message-ID: <4A56CEF8.8040106@cn.fujitsu.com>
Date: Fri, 10 Jul 2009 13:17:44 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: Re: [PATCH 2/2] tracing/kmemtrace: Use the %pf format
References: <1247107590-6428-1-git-send-email-fweisbec@gmail.com> <1247107590-6428-3-git-send-email-fweisbec@gmail.com>
In-Reply-To: <1247107590-6428-3-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> Remove the obsolete seq_print_ip_sym() usage and replace it
> by the %pf format in order to print function symbols.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>

...

> -	/* Skip node */
> -	ret = trace_seq_printf(s, "       ");
> +	/* Skip node and print call site*/

a nitpick:

missing a space before '*/'

> +	ret = trace_seq_printf(s, "       %pf\n", (void *)entry->call_site);

