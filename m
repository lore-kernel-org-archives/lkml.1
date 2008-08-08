Return-Path: <linux-kernel-owner+w=401wt.eu-S1756684AbYHHSGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684AbYHHSGf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 14:06:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752489AbYHHSG2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 14:06:28 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:52330 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752200AbYHHSG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 14:06:28 -0400
Subject: Re: [RFC][PATCH 0/4] kernel-based checkpoint restart
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: containers@lists.linux-foundation.org, Theodore Tso <tytso@mit.edu>,
       linux-kernel@vger.kernel.org, Oren Laadan <orenl@cs.columbia.edu>
In-Reply-To: <200808081125.12706.arnd@arndb.de>
References: <20080807224033.FFB3A2C1@kernel>
	 <200808081125.12706.arnd@arndb.de>
Content-Type: text/plain
Date: Fri, 08 Aug 2008 11:06:24 -0700
Message-Id: <1218218784.19082.10.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-08-08 at 11:25 +0200, Arnd Bergmann wrote:
> >         pid_t pid = getpid();
> >         int ret;
> >
> >         ret = syscall(__NR_checkpoint, pid, STDOUT_FILENO, 0);
> 
> Interface-wise, I would consider checkpointing yourself signficantly
> different from checkpointing some other thread. If checkpointing
> yourself is the common case, it probably makes sense to allow passing
> of pid=0 for this.

I don't think it is the common case.  Probably now when we're screwing
around with it, but not in the future.  Do you think it is worth adding
the pid=0 handling?

-- Dave

