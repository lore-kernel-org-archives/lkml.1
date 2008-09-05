Return-Path: <linux-kernel-owner+w=401wt.eu-S1753619AbYIEUpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619AbYIEUpX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 16:45:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751564AbYIEUpL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 16:45:11 -0400
Received: from one.firstfloor.org ([213.235.205.2]:47039 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbYIEUpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 16:45:10 -0400
Date: Fri, 5 Sep 2008 22:48:30 +0200
From: Andi Kleen <andi@firstfloor.org>
To: pageexec@freemail.hu
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       tglx@tglx.de, hpa@zytor.com
Subject: Re: [patch] Add basic sanity checks to the syscall execution patch
Message-ID: <20080905204830.GB18288@one.firstfloor.org>
References: <20080905172644.GV18288@one.firstfloor.org> <48C18BB8.13126.4E8982B@pageexec.freemail.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48C18BB8.13126.4E8982B@pageexec.freemail.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2008 at 09:42:48PM +0200, pageexec@freemail.hu wrote:
> On 5 Sep 2008 at 19:26, Andi Kleen wrote:
> 
> > 
> > First such checkers already exist -- they are called root kit checkers.
> > There are various around. 
> > Usually operate from user space. You could run them in a cron job.
> 
> how trivial do you think it is for *kernel* code to evade *userland*
> checking it? ;) otherwise agreed with rest.

It depends on where the userland runs. e.g. if it's under a hypervisor
and in a separate domain it should be reasonably safe.

And then I don't think it is much difference between Ingo's kernel
checker and a user land checker. Both can be disabled it you know
about them.

-Andi

-- 
ak@linux.intel.com
