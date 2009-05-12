Return-Path: <linux-kernel-owner+w=401wt.eu-S1755173AbZELJPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755173AbZELJPv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 05:15:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752168AbZELJPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 05:15:41 -0400
Received: from viefep11-int.chello.at ([62.179.121.31]:4741 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160AbZELJPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 05:15:40 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH]sched: fix typo in sched-rt-group.txt file
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: leemgs1@gmail.com
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>,
       tglx <tglx@linutronix.de>, williams <williams@redhat.com>
In-Reply-To: <1242117459.31161.11.camel@centos51>
References: <1242117459.31161.11.camel@centos51>
Content-Type: text/plain
Date: Tue, 12 May 2009 11:15:38 +0200
Message-Id: <1242119738.11251.322.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-05-12 at 17:37 +0900, GeunSik Lim wrote:
> 
> 
> Dear Ingo,
> 
> I found typo about the range of static priority ( = realtime priority )
> in "./Documentation/scheduler/sched-rt-group.txt" file.
> 
> If I don't understand static priority levels, Correct me.

Right, that 'confusion' stems from the fact that our in-kernel priority
lists do consider all 140 priorities.

The patch looks good though.

> commit d6af702008117ca489a2f5476239d1688a517e98
> Author: GeunSik,Lim <leemgs1@gmail.com>
> Date:   Tue May 12 17:20:32 2009 +0900
> 
>     sched: fix typo in sched-rt-group.txt file
>     
>     Fix typo about static priority's range.
>      Kernel Space priority: 0   to 99   --> User Space RT priority 99 to 0
>      Kernel Space priority: 100 to 139  --> User Space nice -20 to 19
>     
>     Signed-off-by: GeunSik Lim <geunsik.lim@samsung.com>
> 
> diff --git a/Documentation/scheduler/sched-rt-group.txt b/Documentation/scheduler/sched-rt-group.txt
> index 5ba4d3f..1537146 100644
> --- a/Documentation/scheduler/sched-rt-group.txt
> +++ b/Documentation/scheduler/sched-rt-group.txt
> @@ -169,7 +169,7 @@ get their allocated time.
>  
>  Implementing SCHED_EDF might take a while to complete. Priority Inheritance is
>  the biggest challenge as the current linux PI infrastructure is geared towards
> -the limited static priority levels 0-139. With deadline scheduling you need to
> +the limited static priority levels 0-99. With deadline scheduling you need to
>  do deadline inheritance (since priority is inversely proportional to the
>  deadline delta (deadline - now).
>  
> 
> 
> -----------------------------------------------
> To unsubscribe from this list: send the line "unsubscribe linux-***" 
> in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> GeunSik Lim (ELS - OS Group - S/W Lab - SAIT - SAMSUNG)
> e-Mail  :1) geunsik.lim@samsung.com
>          2) leemgs@gmail.com , leemgs1@gmail.com
> HomePage: http://intomail.dnip.net/invain/me/
> -----------------------------------------------

