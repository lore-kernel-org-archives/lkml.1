Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932625Ab0BCRCA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 12:02:00 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:49090 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932615Ab0BCRB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 12:01:57 -0500
X-Authority-Analysis: v=1.0 c=1 a=7x9RA51NZSMA:10 a=7U3hwN5JcxgA:10 a=20KFwNOVAAAA:8 a=my9483RHBqORIf2iYZ8A:9 a=p-G8_5qcMnUmS-pih6RamKbdEeQA:4 a=jEp0ucaQiEUA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH] trace-cmd: teach git to ignore dependency files (*.d)
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: John Kacur <jkacur@redhat.com>
Cc: linux-kernel@vger.kernel.org, Darren Hart <dvhltc@us.ibm.com>
In-Reply-To: <alpine.LFD.2.00.1002031749320.6302@localhost.localdomain>
References: <alpine.LFD.2.00.1002031749320.6302@localhost.localdomain>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Wed, 03 Feb 2010 12:01:55 -0500
Message-ID: <1265216515.24386.7.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-02-03 at 17:51 +0100, John Kacur wrote:
> >From fc439caf5a0df5ff735d8f783a29709849c4d83b Mon Sep 17 00:00:00 2001
> From: John Kacur <jkacur@redhat.com>
> Date: Wed, 3 Feb 2010 16:39:15 +0100
> Subject: [PATCH] trace-cmd: teach git to ignore dependency files (*.d)
> 
> Teach git to ignore dependency files (*.d)

Thanks, but this is already in the master branch. But it ignores ".*.d"
instead.

-- Steve

> 
> Signed-off-by: John Kacur <jkacur@redhat.com>
> ---
>  .gitignore |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/.gitignore b/.gitignore
> index 8e8f5a4..0dcd8cd 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -5,6 +5,7 @@ trace-cmd
>  *.dat
>  *.patch
>  *~
> +*.d
>  kernelshark
>  trace-graph
>  trace-view


