Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932546Ab0BDTcv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 14:32:51 -0500
Received: from mail.gmx.net ([213.165.64.20]:43456 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932355Ab0BDTco (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 14:32:44 -0500
X-Authenticated: #28250155
X-Provags-ID: V01U2FsdGVkX19muJVQWZRmrOLXs19qcpvG6egRcul85wYqd3rYQz
	KnXiNTu5Z0vxEL
From: Sven Joachim <svenjoac@gmx.de>
To: Greg KH <greg@kroah.com>
Cc: Ben Hutchings <ben@decadent.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       stable-review@kernel.org, stable@kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [stable] [PATCH] Fix 'flush_old_exec()/setup_new_exec()' split
References: <1265245849.3362.1.camel@localhost>
	<1265256174.2952.11.camel@localhost>
	<alpine.LFD.2.00.1002032135380.3707@localhost.localdomain>
	<1265272174.2952.20.camel@localhost>
	<20100204143848.GB15438@kroah.com> <87sk9gbzzt.fsf@turtle.gmx.de>
	<20100204185752.GA18595@kroah.com>
Date: Thu, 04 Feb 2010 20:32:32 +0100
In-Reply-To: <20100204185752.GA18595@kroah.com> (Greg KH's message of "Thu, 4
	Feb 2010 10:57:52 -0800")
Message-ID: <87iqacdcfj.fsf@turtle.gmx.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.64000000000000001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-02-04 19:57 +0100, Greg KH wrote:

> On Thu, Feb 04, 2010 at 07:46:30PM +0100, Sven Joachim wrote:
>> It seems they are all there, but on my system with 64-bit kernel and
>> 32-bit userland, 2.6.32.8-rc1 still panics in the way noticed by Ben.
>
> Does 2.6.33-rc6 also cause you the same problem?

A build from Linus' current git tree (commit 7ab02af42 was added after
2.6.33-rc6, so I skipped that version) does not show the problem.
Actually, I'm using it right now.

Sven
