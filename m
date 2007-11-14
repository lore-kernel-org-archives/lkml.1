Return-Path: <linux-kernel-owner+w=401wt.eu-S1762140AbXKNRvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762140AbXKNRvY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 12:51:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761846AbXKNRvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 12:51:05 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:39313 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761742AbXKNRvD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 12:51:03 -0500
Date: Wed, 14 Nov 2007 20:48:40 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Grant Wilson <grant.wilson@zen.co.uk>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc1-gb4f5550 oops
Message-ID: <20071114174840.GA14193@tv-sign.ru>
References: <20071114151708.GA12355@tv-sign.ru> <20071114163749.GH3359@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071114163749.GH3359@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14, Srivatsa Vaddagiri wrote:
>
> On Wed, Nov 14, 2007 at 06:17:08PM +0300, Oleg Nesterov wrote:
> > Suppose that old user_struct/task_group is freed/reused, and the task does
> 
> Shouldn't this old user actually be the root user_struct?

Well, the S_ISUID application can switch ->user from !root_user (note that
setuid exec doesn't change ->user), and we also have CAP_SETUID...

But yes, I agree, this all is very unlikely.

Oleg.

