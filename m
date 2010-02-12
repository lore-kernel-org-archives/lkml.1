Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386Ab0BLImq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 03:42:46 -0500
Received: from hera.kernel.org ([140.211.167.34]:47806 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751659Ab0BLImo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 03:42:44 -0500
Message-ID: <4B75159C.6080100@kernel.org>
Date: Fri, 12 Feb 2010 17:47:24 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Simon Kagstrom <simon.kagstrom@netinsight.net>
CC: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
       laijs@cn.fujitsu.com, rusty@rustcorp.com.au, akpm@linux-foundation.org,
       mingo@elte.hu
Subject: Re: [PATCH v2] core: workqueue: return on workqueue recursion
References: <20100203122755.0fd4fb7e@marrow.netinsight.se>	<20100203194350.GA13824@redhat.com>	<4B6A2D29.3010804@kernel.org> <20100204090216.131fc73f@marrow.netinsight.se>
In-Reply-To: <20100204090216.131fc73f@marrow.netinsight.se>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 12 Feb 2010 08:39:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/2010 05:02 PM, Simon Kagstrom wrote:
> When the workqueue is flushed from workqueue context (recursively), the
> system enters a strange state where things at random (dependent on the
> global workqueue) start misbehaving. For example, for us the console and
> logins locks up while the web server continues running.
> 
> The system becomes unstable since the workqueue barrier locks the
> workqueue. This patch instead returns if the workqueue is flushed
> recursively, which keeps the workqueue alive but warns.
> 
> Signed-off-by: Simon Kagstrom <simon.kagstrom@netinsight.net>

applied to wq tree.  Will push out when the merge window opens.

Thanks.

-- 
tejun
