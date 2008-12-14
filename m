Return-Path: <linux-kernel-owner+w=401wt.eu-S1754034AbYLNJ4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034AbYLNJ4V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 04:56:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751857AbYLNJ4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 04:56:12 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49467 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751793AbYLNJ4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 04:56:11 -0500
Date: Sun, 14 Dec 2008 01:55:56 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] add init_start_cpus to config boot cpus -v2
Message-Id: <20081214015556.16615d55.akpm@linux-foundation.org>
In-Reply-To: <4944B5A4.9060706@kernel.org>
References: <4944A279.5020009@kernel.org>
	<20081213221842.583f1e38.akpm@linux-foundation.org>
	<4944B5A4.9060706@kernel.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Dec 2008 23:28:36 -0800 Yinghai Lu <yinghai@kernel.org> wrote:

> 
> Impact: new command line
> 
> so could select cpus to be started during init stage.

I already knew that :(


> example:
> init_start_cpus=2,4,6
> to start core 0 only on every node or thread 0 or all cores
> 
> init_start_cpus=0
> not start other APs, and later let user to use
>  echo 1 > /sys/devices/cpu/cpu2
> to start them in user space.
> 

But why?  Why is this useful?  Why did you even bother writing the
code?  Who wants this?  For what reason?  What value has it?

This stuff matters.

> +static __initdata cpumask_var_t cpu_init_start_mask;

OK.

I also suggested that this code not be added in init/main.c.  What
happened to that idea?


