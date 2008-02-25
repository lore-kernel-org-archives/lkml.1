Return-Path: <linux-kernel-owner+w=401wt.eu-S1756313AbYBYGUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756313AbYBYGUj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 01:20:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752958AbYBYGUb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 01:20:31 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:35080 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752679AbYBYGUa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 01:20:30 -0500
Subject: Re: [RFC] [PATCH] To refuse users from probing preempt_schedule()
From: Dave Hansen <haveblue@us.ibm.com>
To: srinivasa <srinivasa@in.ibm.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       ananth@in.ibm.com, Jim Keniston <jkenisto@us.ibm.com>,
       srikar@linux.vnet.ibm.com
In-Reply-To: <200802251127.40579.srinivasa@in.ibm.com>
References: <200802251127.40579.srinivasa@in.ibm.com>
Content-Type: text/plain
Date: Sun, 24 Feb 2008 22:20:24 -0800
Message-Id: <1203920424.6662.14.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-02-25 at 11:27 +0530, srinivasa wrote:
> This patch prohibits user from probing preempt_schedule(). One way of
> prohibiting the user from probing functions is by marking such 
> functions with __kprobes. But this method doesn't work for those functions,
> which are already marked to different section like preempt_schedule()
> (belongs to __sched section). So we use blacklist approach to refuse user
> from probing these functions.

preempt_schedule() does sound really, really important.  But, what kinds
of functions can't be kprobed?  It would be nice to give that blacklist
a nice comment on the topic. :)

Also, have you strained your brains to think of other functions that
this should be applied to?  Is it just for functions that are sensitive
and already have an assigned section?  Might be nice to call that out
explicitly.

-- Dave

