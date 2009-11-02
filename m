Return-Path: <linux-kernel-owner+w=401wt.eu-S1755413AbZKBPZQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413AbZKBPZQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 10:25:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755352AbZKBPZN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 10:25:13 -0500
Received: from hera.kernel.org ([140.211.167.34]:57379 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755320AbZKBPZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 10:25:09 -0500
Message-ID: <4AEEF9AE.1090904@kernel.org>
Date: Tue, 03 Nov 2009 00:24:30 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; ko-KR; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: npiggin@suse.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH 1/1] MM: slqb, fix per_cpu access
References: <4AEE5EA2.6010905@kernel.org> <1257151763-11507-1-git-send-email-jirislaby@gmail.com>
In-Reply-To: <1257151763-11507-1-git-send-email-jirislaby@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009년 11월 02일 17:49, Jiri Slaby wrote:
> We cannot use the same local variable name as the declared per_cpu
> variable since commit "percpu: remove per_cpu__ prefix."
> 
> Otherwise we would see crashes like:
> general protection fault: 0000 [#1] SMP
> last sysfs file:
> CPU 1
> Modules linked in:
> Pid: 1, comm: swapper Tainted: G        W  2.6.32-rc5-mm1_64 #860
> RIP: 0010:[<ffffffff8142ff94>]  [<ffffffff8142ff94>] start_cpu_timer+0x2b/0x87
> ...
> 
> Use slqb_ prefix for the global variable so that we don't collide
> even with the rest of the kernel (s390 and alpha need this).
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> Cc: Nick Piggin <npiggin@suse.de>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Christoph Lameter <cl@linux-foundation.org>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
