Return-Path: <linux-kernel-owner+w=401wt.eu-S933744AbZJMIIn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933744AbZJMIIn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 04:08:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933681AbZJMIIm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 04:08:42 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51508 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S933680AbZJMIIl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 04:08:41 -0400
Message-ID: <4AD4351D.9090003@cn.fujitsu.com>
Date: Tue, 13 Oct 2009 16:06:53 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Stefan Assmann <sassmann@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 1/3] ftrace: add kernel command line graph function filtering
References: <1255419540-5481-1-git-send-email-fweisbec@gmail.com> <1255419540-5481-2-git-send-email-fweisbec@gmail.com>
In-Reply-To: <1255419540-5481-2-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +#ifdef CONFIG_FUNCTION_GRAPH_TRACER
> +static int __init set_graph_function(char *str)
> +{
> +	strncpy(ftrace_graph_buf, str, FTRACE_FILTER_SIZE);

should use strlcpy().

> +	return 1;
> +}
