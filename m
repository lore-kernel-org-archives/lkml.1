Return-Path: <linux-kernel-owner+w=401wt.eu-S1759299AbZKFEag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759299AbZKFEag (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 23:30:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759229AbZKFEag
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 23:30:36 -0500
Received: from mail.gmx.net ([213.165.64.20]:53148 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755840AbZKFEaf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 23:30:35 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+1o9B0Wli1VxVEhGkDbwFxmxHQKDmsLJObC2vjFU
	uRwQesOl9bpKWR
Subject: Re: [PATCH -tip] sched: fix bug that task run on a wrong and
 unallowed cpu
From: Mike Galbraith <efault@gmx.de>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Eric Paris <eparis@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4AF39B6D.50001@cn.fujitsu.com>
References: <4AF39B6D.50001@cn.fujitsu.com>
Content-Type: text/plain
Date: Fri, 06 Nov 2009 05:30:38 +0100
Message-Id: <1257481838.6394.56.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-11-06 at 11:43 +0800, Lai Jiangshan wrote:
> a1f84a3ab8e002159498814eaa7e48c33752b04b brought a bug that
> task may run on a unallowed cpu.
> 
> In my box, this bug trigger debug_smp_processor_id()'s complaints:

That commit is missing an allowed check.

	-Mike

