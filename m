Return-Path: <linux-kernel-owner+w=401wt.eu-S1760139AbYEVUkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760139AbYEVUkb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 16:40:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756353AbYEVUkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 16:40:20 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50349 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755239AbYEVUkS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 16:40:18 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Petr Tesarik <ptesarik@suse.cz>
Cc: Luming Yu <luming.yu@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-ia64@vger.kernel.org
Subject: Re: [RFC PATCH] set TASK_TRACED before arch_ptrace code to fix a
	race
In-Reply-To: Petr Tesarik's message of  Thursday, 22 May 2008 14:12:47 +0200 <1211458368.5610.36.camel@elijah.suse.cz>
References: <3877989d0805211947i54bacc7cv619541e9b40824fb@mail.gmail.com>
	<1211446045.5610.33.camel@elijah.suse.cz>
	<3877989d0805220216o5add20ddye2a1fde98a0c1e69@mail.gmail.com>
	<20080522111826.BB90326FA24@magilla.localdomain>
	<1211458368.5610.36.camel@elijah.suse.cz>
Emacs: an inspiring example of form following function... to Hell.
Message-Id: <20080522203940.8CA5F26FA24@magilla.localdomain>
Date: Thu, 22 May 2008 13:39:40 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 2008-05-22 at 04:18 -0700, Roland McGrath wrote:
> > I really cannot figure out from anything you've said what the failure mode
> > is or how you think it should be affected.
> 
> At least you should be able to see the related bug report at:
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=446200

That really doesn't help (yes, I can see it).  That is a bug for the RHEL4
kernel, which is based on a much older kernel and has none of the code
we're discussing here.  The test case is a simple program that blocks
SIGTRAP using sigprocmask, then forks and exec's a simple shell script that
just runs some random command; run this under strace.  There is no further
information in that bugzilla report that helps us understand the behavior
of that test case in the current kernel, which Luming says has a problem.


Thanks,
Roland
