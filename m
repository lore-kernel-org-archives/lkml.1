Return-Path: <linux-kernel-owner+w=401wt.eu-S1758004AbZBSB5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758004AbZBSB5U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 20:57:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752955AbZBSB5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 20:57:12 -0500
Received: from hera.kernel.org ([140.211.167.34]:37092 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751954AbZBSB5L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 20:57:11 -0500
Message-ID: <499CBC58.2060406@kernel.org>
Date: Thu, 19 Feb 2009 10:56:40 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86,4kstack: use percpu data for hardirq and softirq
 stack
References: <499A3322.3030704@cn.fujitsu.com>
In-Reply-To: <499A3322.3030704@cn.fujitsu.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 19 Feb 2009 01:56:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lai Jiangshan wrote:
> Impact: economize memory for large NR_CPUS
> 
> percpu data is setup earlier than irq, we can use percpu data
> to economize memory.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Merged into tj-percpu (which is generally merged into x86/core/percpu)
with trivial subject change.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git tj-percpu

The commit ID is ff6274badd53e42d7aa326178156c265a9fa4cd8.

Thanks.

-- 
tejun
