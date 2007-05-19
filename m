Return-Path: <linux-kernel-owner+w=401wt.eu-S1764703AbXESU4G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764703AbXESU4G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 16:56:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764215AbXESUzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 16:55:54 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:5718 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762329AbXESUzx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 16:55:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=UdyG+OOuatCpgEDozxk6QFMS/C9ULmMJppEljbzD7YtGzA4sW+agSSkZIQ51xhHgM3CVzHeq66D1AZkE/YIxanlCYQZm0Y3Ha6d3rnf7jZnG+kx5q1xWfMSgbS2Cg++wqjA+zM6j5sa2PQ2CxHjU7ZDmnX9OgrZgb7tE4qz9zBI=
Message-ID: <2c0942db0705191355x740bf664ud36c3cc4b39d210f@mail.gmail.com>
Date: Sat, 19 May 2007 13:55:52 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Diego Calleja" <diegocg@gmail.com>
Subject: Re: Sched - graphic smoothness under load - cfs-v13 sd-0.48
Cc: "Bill Davidsen" <davidsen@tmr.com>,
       "Linux Kernel M/L" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070519223603.8d70cd6e.diegocg@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <464F57DD.2000309@tmr.com>
	 <20070519223603.8d70cd6e.diegocg@gmail.com>
X-Google-Sender-Auth: 31aabbf5c3b109cd
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/19/07, Diego Calleja <diegocg@gmail.com> wrote:
> El Sat, 19 May 2007 16:02:37 -0400, Bill Davidsen <davidsen@tmr.com> escribió:
>
> > The chart is at http://www.tmr.com/~davidsen/sched_smooth_01.html for
> > your viewing pleasure. The only "tuned" result was with sd, since what I
> > observed was so bad using the default settings. If any scheduler
> > developers would like me to try other tunings or new versions let me know.
>
> How useful is glxgears as benchmark here? The X.org people has been saying
> for ages that "glxgears is not a benchmark".

If you hold everything in the system constant other than the
scheduler, then it's a useful measure of the effects the scheduler has
upon glxgears, regardless of how well or poorly written it might be.

I suspect the X.org people are correct in regards how most people
would try to use it, which would be measurements against different
video cards, CPUs, etc.
