Return-Path: <linux-kernel-owner+w=401wt.eu-S1753107AbZKIB6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753107AbZKIB6Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 20:58:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753073AbZKIB6W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 20:58:22 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:39692 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042AbZKIB6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 20:58:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pc8M4swdD666MASaNMivpyd4nyBTO7yPDHCYvhHRHPI0T6ADHIsFnJCKK+Qgk0NdHx
         lAs7e5ZGD4SglJ/CLmofWQWhMmiK+/iYNvIzMQA0WMDsC1P/I6qJt0J813DGHD4a2xPR
         4V3/WRL0Xj6txyf5iqDiifLaOnHm5inGCrL8w=
Date: Mon, 9 Nov 2009 02:58:16 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org, zhaolei@cn.fujitsu.com,
       Li Zefan <lizf@cn.fujitsu.com>, Thomas Gleixner <tglx@linutronix.de>,
       Jason Baron <jbaron@redhat.com>
Subject: Re: [PATCH] softirq,tracing: enable to trace softirq raise latency
Message-ID: <20091109015812.GA13153@nowhere>
References: <4AF284CF.3010407@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AF284CF.3010407@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 05, 2009 at 03:54:55PM +0800, Lai Jiangshan wrote:
> 
> Add a tracepoint for tracing when softirq action is raised.
> 
> It and the existed tracepoints complete softirq's tracepoints:
> softirq_raise, softirq_entry and softirq_exit.
> 
> And when this tracepoint is used in combination with
> the softirq_entry tracepoint we can determine
> the softirq raise latency.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>


Looks good!

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

