Return-Path: <linux-kernel-owner+w=401wt.eu-S1754691AbXGOFZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691AbXGOFZt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 01:25:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751798AbXGOFZk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 01:25:40 -0400
Received: from mail.gmx.net ([213.165.64.20]:42876 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751044AbXGOFZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 01:25:39 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/Xq3N6pPLXx0PwKNA9oQ/eofOzNWRFlMhGvLWTE7
	D783+aW+2vkOiF
Subject: Re: [patch] CFS scheduler, -v19
From: Mike Galbraith <efault@gmx.de>
To: Ed Tomlinson <edt@aei.ca>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
In-Reply-To: <200707141319.13270.edt@aei.ca>
References: <20070706173319.GA2356@elte.hu>  <200707141319.13270.edt@aei.ca>
Content-Type: text/plain
Date: Sun, 15 Jul 2007 07:25:33 +0200
Message-Id: <1184477133.6378.21.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-07-14 at 13:19 -0400, Ed Tomlinson wrote:
> Hi,

Hi Ed,

> I run a java application at nice 15.  Its been a background application here for as long
> as SD and CFS have been around.  If I have a compile running at nice 0, with v19 java 
> gets so little cpu that the the wrapper that runs to monitor it is timing out waiting for 
> it to start.  This is new in v19 - something in v19 is not meshing well with my mix 
> of applications...
> 
> Kernel is gentoo 2.6.22-r1 + cfs v19
> 
> How can I help to debug this?

I hear Ingo is off having a genuine long weekend, but in the meantime,
you could try echo 30 > /proc/sys/kernel/sched_features to eliminate the
sleeper fairness changes in v19, since that was the biggest change.

Sending a few seconds of logged /proc/sched_debug will also help get a
picture of what's happening, and lovely would be a method to reproduce
the problem locally.

	-Mike

