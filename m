Return-Path: <linux-kernel-owner+w=401wt.eu-S1759043AbYF0UvI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759043AbYF0UvI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 16:51:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755460AbYF0UuT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 16:50:19 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34883 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753590AbYF0UuQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 16:50:16 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Petr Tesarik <ptesarik@suse.cz>
X-Fcc: ~/Mail/linus
Cc: Luming Yu <luming.yu@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-ia64@vger.kernel.org
Subject: Re: [RFC PATCH] set TASK_TRACED before arch_ptrace code to fix a
	race
In-Reply-To: Petr Tesarik's message of  Thursday, 5 June 2008 13:16:45 +0200 <1212664605.15747.16.camel@elijah.suse.cz>
References: <3877989d0805211947i54bacc7cv619541e9b40824fb@mail.gmail.com>
	<20080527040454.053C526FA9E@magilla.localdomain>
	<3877989d0805262249yab130cbyfc5f5e54065cec5c@mail.gmail.com>
	<20080527061209.9A24426FAA6@magilla.localdomain>
	<1211869515.29836.2.camel@elijah.suse.cz>
	<3877989d0806022304w35764b17p9d4c3c95eceae0f5@mail.gmail.com>
	<48450864.6080707@suse.cz>
	<48455619.6040608@suse.cz>
	<3877989d0806031916wf11bb2t3847aa630fb39e60@mail.gmail.com>
	<48465D5C.8000804@suse.cz>
	<3877989d0806041849vb903aaw221de929e2ab8cb9@mail.gmail.com>
	<1212664605.15747.16.camel@elijah.suse.cz>
X-Zippy-Says: I will invent "TIDY BOWL"...
Message-Id: <20080627204954.34F8B154231@magilla.localdomain>
Date: Thu,  5 Jun 2008 17:07:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I _guess_ this is caused by the fact that test2.sh is a shell script, so
> the kernel executes the shell, and maybe utrace produces a second execve
> notifications in this case? Roland, can you shed some light?

Not really.  The utrace kernels Luming is trying are intended to match the
vanilla ptrace behavior.  I don't think it's very useful to worry about the
difference between some utrace kernel and the current vanilla kernel.
Let's just look at what the current vanilla kernel is doing and compare
that to what an older vanilla kernel did if older versions produced
different results for the test case.


Thanks,
Roland
