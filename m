Return-Path: <linux-kernel-owner+w=401wt.eu-S1754669AbZLBP5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669AbZLBP5q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 10:57:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753406AbZLBP5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 10:57:45 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:48877 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbZLBP5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 10:57:45 -0500
Subject: Re: [PATCH -v2 1/2] sched, cputime: cleanups related to
 task_times()
From: Peter Zijlstra <peterz@infradead.org>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Spencer Candland <spencer@bluehost.com>,
       =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
       Oleg Nesterov <oleg@redhat.com>, Balbir Singh <balbir@in.ibm.com>
In-Reply-To: <4B1624C7.7040302@jp.fujitsu.com>
References: <4AFB9029.9000208@jp.fujitsu.com>
	 <20091112144919.GA6218@dhcp-lab-161.englab.brq.redhat.com>
	 <1258038038.4039.467.camel@laptop>
	 <20091112154050.GC6218@dhcp-lab-161.englab.brq.redhat.com>
	 <4B01A8DB.6090002@bluehost.com>
	 <20091117130851.GA3842@dhcp-lab-161.englab.brq.redhat.com>
	 <1258464288.7816.305.camel@laptop>
	 <20091119181744.GA3743@dhcp-lab-161.englab.brq.redhat.com>
	 <4B05F835.10401@jp.fujitsu.com>
	 <20091123100925.GB25978@dhcp-lab-161.englab.brq.redhat.com>
	 <20091123101612.GC25978@dhcp-lab-161.englab.brq.redhat.com>
	 <4B1624C7.7040302@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Dec 2009 16:57:29 +0100
Message-ID: <1259769449.4003.1116.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-02 at 17:26 +0900, Hidetoshi Seto wrote:
> - Remove if({u,s}t)s because no one call it with NULL now.
> - Use cputime_{add,sub}().
> - Add ifndef-endif for prev_{u,s}time since they are used
>   only when !VIRT_CPU_ACCOUNTING.
> 
> Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

