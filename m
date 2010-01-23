Return-Path: <linux-kernel-owner+w=401wt.eu-S1755712Ab0AWCBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755712Ab0AWCBz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 21:01:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754369Ab0AWCBz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 21:01:55 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55952 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753122Ab0AWCBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 21:01:54 -0500
Date: Fri, 22 Jan 2010 17:59:44 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Andrew Morton <akpm@linux-foundation.org>
cc: "H. Peter Anvin" <hpa@zytor.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       =?UTF-8?Q?Ozan_=C3=87a=C4=9Flayan?= <ozan@pardus.org.tr>,
       Yinghai Lu <yinghai@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       mingo@elte.hu, a.p.zijlstra@chello.nl, stable@kernel.org,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: RFC: deprecate CONFIG_X86_CPU_DEBUG and schedule it for rapid
 removal
In-Reply-To: <20100122165356.55cf88aa.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.2.00.1001221755320.13231@localhost.localdomain>
References: <4B4E1633.8010700@pardus.org.tr> <201001162312.34189.rjw@sisk.pl> <4B52D6E2.8000904@pardus.org.tr> <201001171444.14551.rjw@sisk.pl> <4B53B8DD.9000809@zytor.com> <20100122165356.55cf88aa.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 22 Jan 2010, Andrew Morton wrote:
> 
> We know that enabling this feature will cause some machines to hang,
> and that this problem has existed for six months.
> 
> Would it not be better to fix that problem (perhaps just with the
> revert) so that 2.6.33, 2.6.32.x and earlier can be fixed?  Then we can
> nuke the feature in 2.6.34.

Another way of looking at is "we know it's been broken for six months, and 
clearly nobody really ever enabled it in any distro, and even getting a 
bug report on it took forever. So why keep it around at all"?

So I'd personally rather just remove it outright than deprecate it or even 
try to fix it. Since clearly absolutely nobody depends on it.

The usual reason for deprecating a feature is to give people time to move 
away from it, but since clearly nobody uses it...

		Linus
