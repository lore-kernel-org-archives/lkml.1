Return-Path: <linux-kernel-owner+w=401wt.eu-S935584AbYBGV1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935584AbYBGV1q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 16:27:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760329AbYBGV1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 16:27:36 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:43457 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754992AbYBGV1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 16:27:35 -0500
Date: Thu, 7 Feb 2008 13:26:04 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Jason Baron <jbaron@redhat.com>
Cc: mathieu.desnoyers@polymtl.ca, akpm@linux-foundation.org, mingo@elte.hu,
       fche@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 4/4] make pr_debug() dynamic - update docs
Message-Id: <20080207132604.ff93b028.randy.dunlap@oracle.com>
In-Reply-To: <20080207211349.GF14732@redhat.com>
References: <20080207211349.GF14732@redhat.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Feb 2008 16:13:49 -0500 Jason Baron wrote:

> 
> -add documentation about pr_debug kernel-parameters.txt
> 
> Signed-off-by: Jason Baron <jbaron@redhat.com>
> ---
> 
>  Documentation/kernel-parameters.txt |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index cf38689..6d524bb 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -1494,6 +1494,11 @@ and is between 256 and 4096 characters. It is defined in the file
>  			autoconfiguration.
>  			Ranges are in pairs (memory base and size).
>  
> +	pr_debug
> +			Enables pr_debug() calls if the immediate
> +			infrastructure has been enabled. These can also be
> +			switched on/off via /proc/sys/debug/pr_debug.

Is this actually Enables/disables?
I.e., is this actually pr_debug=<int> ?
If so, please document that also.  If not, why not?

>  	print-fatal-signals=
>  			[KNL] debug: print fatal signals
>  			print-fatal-signals=1: print segfault info to



---
~Randy
