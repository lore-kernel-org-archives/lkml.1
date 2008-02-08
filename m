Return-Path: <linux-kernel-owner+w=401wt.eu-S932212AbYBHPL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932212AbYBHPL1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 10:11:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757850AbYBHPLS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 10:11:18 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:41027 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758250AbYBHPLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 10:11:17 -0500
Subject: Re: [PATCH] proc: Add RLIMIT_RTTIME to /proc/<pid>/limits
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Eugene Teo <eugeneteo@kernel.sg>
Cc: linux-kernel@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20080208145950.GA3910@kernel.sg>
References: <20080208145950.GA3910@kernel.sg>
Content-Type: text/plain
Date: Fri, 08 Feb 2008 16:10:45 +0100
Message-Id: <1202483445.6292.1.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-02-08 at 22:59 +0800, Eugene Teo wrote:
> RLIMIT_RTTIME was introduced to allow the user to set a runtime timeout on
> real-time tasks: http://lkml.org/lkml/2007/12/18/218. This patch updates
> /proc/<pid>/limits with the new rlimit.

Ah, didn't know about that file, thanks!

> Signed-off-by: Eugene Teo <eugeneteo@kernel.sg>

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

> ---
>  fs/proc/base.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index c59852b..dcf7be8 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -412,6 +412,7 @@ static const struct limit_names lnames[RLIM_NLIMITS] = {
>  	[RLIMIT_MSGQUEUE] = {"Max msgqueue size", "bytes"},
>  	[RLIMIT_NICE] = {"Max nice priority", NULL},
>  	[RLIMIT_RTPRIO] = {"Max realtime priority", NULL},
> +	[RLIMIT_RTTIME] = {"Max realtime timeout", "us"},
>  };
>  
>  /* Display limits for a process */

