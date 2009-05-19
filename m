Return-Path: <linux-kernel-owner+w=401wt.eu-S1754184AbZESMzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184AbZESMzZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 08:55:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752614AbZESMzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 08:55:19 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:40966 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372AbZESMzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 08:55:18 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4A12AC0D.7000701@s5r6.in-berlin.de>
Date: Tue, 19 May 2009 14:54:37 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.21) Gecko/20090411 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: Ingo Molnar <mingo@elte.hu>, Jiri Slaby <jirislaby@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing: use strlcpy instead of strncpy
References: <4A11480F.3030000@cn.fujitsu.com> <4A11CB5C.8070800@gmail.com> <4A1210B6.80605@cn.fujitsu.com>
In-Reply-To: <4A1210B6.80605@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lai Jiangshan wrote:
> [Impact] cleanup

Well, not entirely.

> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -155,8 +155,8 @@ struct trace_boot_ret {
>  struct trace_branch {
>  	struct trace_entry	ent;
>  	unsigned	        line;
> -	char			func[TRACE_FUNC_SIZE+1];
> -	char			file[TRACE_FILE_SIZE+1];
> +	char			func[TRACE_FUNC_SIZE];
> +	char			file[TRACE_FILE_SIZE];
>  	char			correct;
>  };

(without change of the TRACE_????_SIZE definition)

Better avoid a categorization of a patch if the change's scope exceeds 
that of the categorization.
-- 
Stefan Richter
-=====-=-=== -=-= -==-=
http://arcgraph.de/sr/
