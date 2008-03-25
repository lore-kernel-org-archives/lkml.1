Return-Path: <linux-kernel-owner+w=401wt.eu-S1755768AbYCYOco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755768AbYCYOco (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 10:32:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754200AbYCYOcf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 10:32:35 -0400
Received: from one.firstfloor.org ([213.235.205.2]:52128 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754041AbYCYOce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 10:32:34 -0400
Date: Tue, 25 Mar 2008 15:35:44 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, ebiederm@xmission.com,
       xemul@openvz.org, pavel@ucw.cz, sds@tycho.nsa.gov, roland@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ptrace: it is fun to strace /sbin/init
Message-ID: <20080325143544.GP2170@one.firstfloor.org>
References: <20080323135110.GA294@tv-sign.ru> <20080324152906.dee7b272.akpm@linux-foundation.org> <20080324225611.GA157@tv-sign.ru> <20080324160819.cea2d921.akpm@linux-foundation.org> <87r6dzi0mw.fsf@basil.nowhere.org> <m3fxuedh3m.fsf@maximus.localdomain> <20080325142259.GO2170@one.firstfloor.org> <m37ifqdgfu.fsf@maximus.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m37ifqdgfu.fsf@maximus.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2008 at 03:30:29PM +0100, Krzysztof Halasa wrote:
> Andi Kleen <andi@firstfloor.org> writes:
> 
> > The problem is that you can deadlock if you are not very careful.
> 
> I can damage the system in trillion ways, one more is not a problem
> :-)

We don't actually have that many ways for hard deadlocks even
as root (short of doing really nasty things on /dev/kmem) 

> Hopefully someone will write the details down to enable root to be
> very careful.

Sure, but if the deadlocks can be avoided on the kernel level (just
making sure the children are already reaped) then it would be even
better.

-Andi
