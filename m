Return-Path: <linux-kernel-owner+w=401wt.eu-S1757432AbZEZUXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757432AbZEZUXT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 16:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753466AbZEZUXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 16:23:11 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:46620 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753460AbZEZUXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 16:23:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sV3u+jBBsYtO0ssGcyxjg68AYCWHOpdQerfbFp+Rspp5QC0A4Jup1hxCfPoBybZY2T
         xLPArUS8idilqK8HIR3FGw1RIyqRfWzC2+Ets/4SHis/Gy7BXBb8pbR8Z4A5hSu30z+9
         RcHVDGPzud4ggHCAg9ktaVEsXL/y6xZHzkEUY=
Date: Tue, 26 May 2009 22:23:08 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Zhaolei <zhaolei@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Ingo Molnar <mingo@elte.hu>, Tom Zanussi <tzanussi@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] tracing/workqueue: Get rid of searching last
	executed worklet in probe_worklet_complete()
Message-ID: <20090526202306.GE5969@nowhere>
References: <4A153345.3040905@cn.fujitsu.com> <4A1610B6.7010203@cn.fujitsu.com> <20090522183739.GA26234@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090522183739.GA26234@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 22, 2009 at 08:37:39PM +0200, Oleg Nesterov wrote:
> On 05/22, Zhaolei wrote:
> >
> > We don't need search workqueue's worklet list for worklet which was latest
> > executed, instead, we can use a pointer in cpu_workqueue_stats to remember
> > which worklet was just executed.
> 
> Thanks Zhao, I think this is correct.
> 
> Oleg.


May I add your Acked-by then?

Thanks. 

