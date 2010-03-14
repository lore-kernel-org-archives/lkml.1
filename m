Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246Ab0CNCLx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 21:11:53 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:57252 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752882Ab0CNCLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 21:11:51 -0500
Subject: Re: Q: select_fallback_rq() && cpuset_lock()
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20100313192823.GA21462@redhat.com>
References: <20100309180615.GA11681@redhat.com>
	 <1268239242.5279.46.camel@twins> <20100310173018.GA1294@redhat.com>
	 <1268244075.5279.53.camel@twins> <20100310183259.GA23648@redhat.com>
	 <20100311145248.GA12907@redhat.com> <1268321759.5037.113.camel@laptop>
	 <20100311161909.GA16008@redhat.com>  <20100313192823.GA21462@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 14 Mar 2010 03:11:39 +0100
Message-ID: <1268532699.9440.3.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-03-13 at 20:28 +0100, Oleg Nesterov wrote:
> 
> Peter, I seem to see the simple fix for the discussed cpuset problems,
> but it turns out sched.c has more problems evem without cpusets.
> 
> I'll try to send the whole series on Monday, but perhaps you can look
> at the attached compile-tested patches (especially 2 and 3) to quickly
> correct me if the 3rd one is wrong.
> 
> The subsequent fix in cpuset.c depends on the locking rules enforced
> by 2-3. 

In as far as I can trust my jet-lagged brain, they look good. I'll try
and have another look later.

