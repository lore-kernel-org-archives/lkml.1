Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757405Ab0BEU4H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 15:56:07 -0500
Received: from mail.gmx.net ([213.165.64.20]:47908 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754309Ab0BEU4F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 15:56:05 -0500
X-Authenticated: #28250155
X-Provags-ID: V01U2FsdGVkX1/tK1kw9Avti598pCmatxhDEBZvLPWfQJCgDbvM7I
	HcwuD6iWuLf+yA
From: Sven Joachim <svenjoac@gmx.de>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: hadi@cyberus.ca, Randolf Pohl <randolf.pohl@gmx.de>, gregkh@suse.de,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [46/74] net: restore ip source validation
References: <20100205143441.280460@gmx.net> <1265381514.5661.1.camel@bigi>
	<87wryr4qkk.fsf@turtle.gmx.de> <m1mxzn8mj5.fsf@fess.ebiederm.org>
Date: Fri, 05 Feb 2010 21:55:58 +0100
In-Reply-To: <m1mxzn8mj5.fsf@fess.ebiederm.org> (Eric W. Biederman's message
	of "Fri, 05 Feb 2010 12:17:50 -0800")
Message-ID: <87pr4jxuzl.fsf@turtle.gmx.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.66000000000000003
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-02-05 21:17 +0100, Eric W. Biederman wrote:

> Bah.  That DEVINET_SYSCTL_ENTRY requires having a binary sysctl
> assigned, just to use as an index.
>
> Which of course trips over all of the fine checks in sysctl_check.c to
> keep people from assigning new binary sysctls by accident.
>
> That is the only place in the kernel where he have that problem, I wonder
> how much work it will be to finish untangling.

Isn't that already done in 2.6.33, looking at commit 83ac201b ?  Forgive
my ignorance, I am a layman.

Sen
