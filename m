Return-Path: <linux-kernel-owner+w=401wt.eu-S1754570AbYKNHmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570AbYKNHmT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 02:42:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750799AbYKNHmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 02:42:08 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:58304 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750734AbYKNHmG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 02:42:06 -0500
Message-ID: <491D2B16.8060000@cn.fujitsu.com>
Date: Fri, 14 Nov 2008 15:39:02 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       corbet@lwn.net
Subject: Re: [PATCH] rcupdate: move synchronize_sched() back to rcupdate.c
 V2
References: <49129310.5000903@cn.fujitsu.com> <20081109005159.GM6917@linux.vnet.ibm.com> <4917A8E7.8060801@cn.fujitsu.com> <20081110184520.GC6685@linux.vnet.ibm.com> <4918D7E4.9030107@cn.fujitsu.com> <20081111010331.GF6685@linux.vnet.ibm.com> <491B9581.2080201@cn.fujitsu.com> <20081113173114.GA6788@linux.vnet.ibm.com> <491CCE58.1040701@cn.fujitsu.com> <20081114021152.GF6788@linux.vnet.ibm.com>
In-Reply-To: <20081114021152.GF6788@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Reviewed-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Paul E. McKenney wrote:
[...]
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
> 
> diff -urpNa -X dontdiff linux-2.6.27/Documentation/RCU/00-INDEX linux-2.6.27-rcu_barrierdoc/Documentation/RCU/00-INDEX
> --- linux-2.6.27/Documentation/RCU/00-INDEX	2008-10-09 15:13:53.000000000 -0700
> +++ linux-2.6.27-rcu_barrierdoc/Documentation/RCU/00-INDEX	2008-11-13 08:46:17.000000000 -0800
> @@ -12,6 +12,8 @@ rcuref.txt
>  	- Reference-count design for elements of lists/arrays protected by RCU
>  rcu.txt
>  	- RCU Concepts
> +rcubarrier.txt
> +	- Unloading modules that use RCU callbacks
>  RTFP.txt
>  	- List of RCU papers (bibliography) going back to 1980.
>  torture.txt
> diff -urpNa -X dontdiff linux-2.6.27/Documentation/RCU/rcubarrier.txt linux-2.6.27-rcu_barrierdoc/Documentation/RCU/rcubarrier.txt
> --- linux-2.6.27/Documentation/RCU/rcubarrier.txt	1969-12-31 16:00:00.000000000 -0800
> +++ linux-2.6.27-rcu_barrierdoc/Documentation/RCU/rcubarrier.txt	2008-11-13 18:08:35.000000000 -0800
[...]

