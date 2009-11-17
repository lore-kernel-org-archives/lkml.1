Return-Path: <linux-kernel-owner+w=401wt.eu-S1754786AbZKQLat@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786AbZKQLat (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 06:30:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754672AbZKQLat
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 06:30:49 -0500
Received: from casper.infradead.org ([85.118.1.10]:59584 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754442AbZKQLas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 06:30:48 -0500
Subject: Re: [PATCH 5/7 v6] hw-breakpoints: Rewrite the hw-breakpoints
 layer on top of perf events
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Prasad <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Jan Kiszka <jan.kiszka@web.de>,
       Jiri Slaby <jirislaby@gmail.com>, Avi Kivity <avi@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Arjan van de Ven <arjan@linux.intel.com>
In-Reply-To: <1257694141-5670-6-git-send-email-fweisbec@gmail.com>
References: <1257694141-5670-1-git-send-email-fweisbec@gmail.com>
	 <1257694141-5670-6-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 Nov 2009 12:30:43 +0100
Message-ID: <1258457443.7816.188.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-11-08 at 16:28 +0100, Frederic Weisbecker wrote:
> @@ -643,6 +662,8 @@ struct perf_event {
>  
>         perf_callback_t                 callback;
>  
> +       perf_callback_t                 event_callback;
> +
>  #endif /* CONFIG_PERF_EVENTS */
>  }; 

And here you add another one.. which is 100% unused in this patch..

