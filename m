Return-Path: <linux-kernel-owner+w=401wt.eu-S1753478AbXJZGrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478AbXJZGrS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 02:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751570AbXJZGrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 02:47:11 -0400
Received: from mail.gmx.net ([213.165.64.20]:58236 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751038AbXJZGrJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 02:47:09 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/Wni1ihrjWIgBKKu4KdqJTVERxotpOy+0oUflnQt
	/LEaTOhEzUMJ2v
Subject: Re: kernel 2.6.23 CFS problem?
From: Mike Galbraith <efault@gmx.de>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: "Wang, Baojun" <wangbj@lzu.edu.cn>, linux-kernel@vger.kernel.org,
       gentoo-user@lists.gentoo.org
In-Reply-To: <20071026044502.GB2458@hacking>
References: <200710261057.48179.wangbj@lzu.edu.cn>
	 <20071026044502.GB2458@hacking>
Content-Type: text/plain
Date: Fri, 26 Oct 2007 08:47:02 +0200
Message-Id: <1193381222.10732.11.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-10-26 at 12:45 +0800, WANG Cong wrote:
> On Fri, Oct 26, 2007 at 10:57:45AM +0800, Wang, Baojun wrote:
> >hi, list
> >
> >  I've upgraded my kernel from 2.6.22.9 to 2.6.23 when it was out, After that 
> >I can't install ELDK 4.1 anymore (The one I installed was crashed), it always 
> >stopped at preparing install package XXX (or YYY sometimes), I've waited for 
> >a very long time(more than 1 hour), but it still the same. After I switch 
> >back to kernel 2.6.22.9, everything is fine. Is there somebody have the some 
> >problem like me?
> >
> 
> What's your XXX or YYY?
> 
> What error messages did you get?
> 
> Why don't you try to update your glibc or something like that?
> 
> I am afraid it's off-topic here.

Not necessarily so if kernel version indeed makes the difference between
hung install and successful completion.

Perhaps he has any tasks stuck in 'D' state?  If so, SysRq-t output for
these would be a good thing to collect.  What leads him to suspect the
process scheduler, etc.  More details are needed.

(I went looking for this package, but there are several, and they're
huge)

	-Mike

