Return-Path: <linux-kernel-owner+w=401wt.eu-S1752756AbXKSSrA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756AbXKSSrA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 13:47:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751335AbXKSSqv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 13:46:51 -0500
Received: from codepoet.org ([166.70.99.138]:60734 "EHLO codepoet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751423AbXKSSqu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 13:46:50 -0500
X-Greylist: delayed 2081 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Nov 2007 13:46:50 EST
Date: Mon, 19 Nov 2007 11:12:07 -0700
From: Erik Andersen <andersen@codepoet.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch/backport] CFS scheduler, -v24, for v2.6.24-rc3, v2.6.23.8, v2.6.22.13, v2.6.21.7
Message-ID: <20071119181207.GA11900@codepoet.org>
Reply-To: andersen@codepoet.org
Mail-Followup-To: andersen@codepoet.org, Ingo Molnar <mingo@elte.hu>,
	linux-kernel@vger.kernel.org
References: <20071119151756.GA25446@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20071119151756.GA25446@elte.hu>
X-No-Junk-Mail: I do not want to get *any* junk mail.
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon Nov 19, 2007 at 04:17:56PM +0100, Ingo Molnar wrote:
> 
> By popular demand, here is release -v24 of the CFS scheduler patch.
> 
> It is a full backport of the latest & greatest scheduler code to 
> v2.6.24-rc3, v2.6.23.8, v2.6.22.13, v2.6.21.7. The patches can be 
> downloaded from the usual place:
> 
>     http://people.redhat.com/mingo/cfs-scheduler/

Doesn't compile with 2.6.21.7:

kernel/sched.c: In function ‘cpu_to_core_group’:
kernel/sched.c:6056: error: ‘per_cpu__cpu_sibling_map’ undeclared (first use in this function)
kernel/sched.c:6056: error: (Each undeclared identifier is reported only once
kernel/sched.c:6056: error: for each function it appears in.)
kernel/sched.c:6056: warning: type defaults to ‘int’ in declaration of ‘type name’
kernel/sched.c:6056: error: invalid type argument of ‘unary *’
kernel/sched.c: In function ‘build_sched_domains’:
kernel/sched.c:6319: error: ‘per_cpu__cpu_sibling_map’ undeclared (first use in this function)
kernel/sched.c:6319: warning: type defaults to ‘int’ in declaration of ‘type name’
kernel/sched.c:6319: error: invalid type argument of ‘unary *’
kernel/sched.c:6330: warning: type defaults to ‘int’ in declaration of ‘type name’
kernel/sched.c:6330: error: invalid type argument of ‘unary *’
make[1]: *** [kernel/sched.o] Error 1
make[1]: *** Waiting for unfinished jobs....

 -Erik

--
Erik B. Andersen             http://codepoet-consulting.com/
--This message was written using 73% post-consumer electrons--
