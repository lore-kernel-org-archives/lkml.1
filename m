Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135Ab0BEFo0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 00:44:26 -0500
Received: from mail.gmx.net ([213.165.64.20]:53415 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751620Ab0BEFoZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 00:44:25 -0500
X-Authenticated: #28250155
X-Provags-ID: V01U2FsdGVkX19rWk9hwiJrmvd2u+MQcUBwH5eTQciOpWjVoIZXB8
	hn2dpT7oZ7OYSK
From: Sven Joachim <svenjoac@gmx.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg KH <greg@kroah.com>, Ben Hutchings <ben@decadent.org.uk>,
       stable-review@kernel.org, stable@kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [stable] [PATCH] Fix 'flush_old_exec()/setup_new_exec()' split
References: <1265245849.3362.1.camel@localhost>
	<1265256174.2952.11.camel@localhost>
	<alpine.LFD.2.00.1002032135380.3707@localhost.localdomain>
	<1265272174.2952.20.camel@localhost>
	<20100204143848.GB15438@kroah.com> <87sk9gbzzt.fsf@turtle.gmx.de>
	<20100204185752.GA18595@kroah.com> <87iqacdcfj.fsf@turtle.gmx.de>
	<alpine.LFD.2.00.1002041135110.3707@localhost.localdomain>
Date: Fri, 05 Feb 2010 06:44:21 +0100
In-Reply-To: <alpine.LFD.2.00.1002041135110.3707@localhost.localdomain> (Linus
	Torvalds's message of "Thu, 4 Feb 2010 11:37:24 -0800 (PST)")
Message-ID: <87eil0dyoa.fsf@turtle.gmx.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.70999999999999996
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-02-04 20:37 +0100, Linus Torvalds wrote:

> Ok, then that's just really odd. I don't think there are any other changes 
> in this area, and the whole init problem sure as hell smells like execve 
> setup problems. And afaik, 2.6.32.8-rc1 should have all the commits from 
> current -git.
>
> Maybe we're looking at a separate issue after all.

Possibly, because a 32-bit 2.6.32.8-rc1 kernel also panics very early.

Sven
