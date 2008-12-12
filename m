Return-Path: <linux-kernel-owner+w=401wt.eu-S1757915AbYLLLpV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757915AbYLLLpV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 06:45:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753065AbYLLLpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 06:45:06 -0500
Received: from ozlabs.org ([203.10.76.45]:43221 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752575AbYLLLpE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 06:45:04 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mike Travis <travis@sgi.com>
Subject: Re: [PATCH 4/4] cpumask: add sysfs displays for configured and disabled cpu maps
Date: Fri, 12 Dec 2008 22:14:54 +1030
User-Agent: KMail/1.10.1 (Linux/2.6.27-9-generic; KDE/4.1.2; i686; ; )
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
References: <20081211112806.499831000@polaris-admin.engr.sgi.com> <20081211112807.139220000@polaris-admin.engr.sgi.com>
In-Reply-To: <20081211112807.139220000@polaris-admin.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812122214.55248.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 December 2008 21:58:10 Mike Travis wrote:
> Impact: add new functionality.
> 
> Add sysfs files "kernel_max" and "offline" to display the max CPU index
> allowed (NR_CPUS-1), and the map of cpus that are offline. 

As discussed, I like this patch.  kernel_max tells you the kernel limit,
and offline tells you if there are any beyond that (other archs need
enhancement for this tho, which would be nice).

Thanks,
Rusty.
