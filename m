Return-Path: <linux-kernel-owner+w=401wt.eu-S932181Ab0AWA4O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932181Ab0AWA4O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 19:56:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753416Ab0AWA4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 19:56:13 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57160 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753503Ab0AWA4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 19:56:13 -0500
Date: Fri, 22 Jan 2010 16:53:56 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Ozan =?UTF-8?Q?=C3=87a=C4=9Flayan?= <ozan@pardus.org.tr>,
       Yinghai Lu <yinghai@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       mingo@elte.hu, a.p.zijlstra@chello.nl, stable@kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: RFC: deprecate CONFIG_X86_CPU_DEBUG and schedule it for rapid
 removal
Message-Id: <20100122165356.55cf88aa.akpm@linux-foundation.org>
In-Reply-To: <4B53B8DD.9000809@zytor.com>
References: <4B4E1633.8010700@pardus.org.tr>
	<201001162312.34189.rjw@sisk.pl>
	<4B52D6E2.8000904@pardus.org.tr>
	<201001171444.14551.rjw@sisk.pl>
	<4B53B8DD.9000809@zytor.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Jan 2010 17:26:53 -0800
"H. Peter Anvin" <hpa@zytor.com> wrote:

> CONFIG_X86_CPU_DEBUG really seems to be causing more problems than it
> ever solved.  This is an RFC for immediately deprecating it, and
> schedule it for removal in the 2.6.34 cycle.
> 
> If this was a high value feature, it would be different -- but it's not
> even close.
> 
> Posting this as an RFC just on the offchance someone actually depends on
> this.
> 

We know that enabling this feature will cause some machines to hang,
and that this problem has existed for six months.

Would it not be better to fix that problem (perhaps just with the
revert) so that 2.6.33, 2.6.32.x and earlier can be fixed?  Then we can
nuke the feature in 2.6.34.

Alternatively, we can nuke the feature from 2.6.33 and 2.6.32.x and
earlier right now.  Where "nuke" might mean "make it difficult to
enable".

Whatever.  Bottom line is that it'd be nice to do something to fix up
2.6.33 and earlier.

