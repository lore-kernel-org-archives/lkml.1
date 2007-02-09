Return-Path: <linux-kernel-owner+w=401wt.eu-S1752461AbXBIWuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752461AbXBIWuU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 17:50:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752463AbXBIWuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 17:50:20 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:2001 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461AbXBIWuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 17:50:19 -0500
X-AuthUser: davidel@xmailserver.org
Date: Fri, 9 Feb 2007 14:50:12 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: David Woodhouse <dwmw2@infradead.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@openvz.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: -mm merge plans for 2.6.21
In-Reply-To: <1171058342.29713.136.camel@pmac.infradead.org>
Message-ID: <Pine.LNX.4.64.0702091442230.2786@alien.or.mcafeemobile.com>
References: <20070208150710.1324f6b4.akpm@linux-foundation.org> 
 <1171042535.29713.96.camel@pmac.infradead.org>  <20070209134516.2367a7aa.akpm@linux-foundation.org>
 <1171058342.29713.136.camel@pmac.infradead.org>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Feb 2007, David Woodhouse wrote:

> On Fri, 2007-02-09 at 13:45 -0800, Andrew Morton wrote:
> > > I would strongly recommend that in the general case, you don't merge new
> > > system calls unless the corresponding compat_ system call is
> > > implemented.
> > 
> > Good point. 
> 
> It's a _damn_ good point, but I see we went ahead and merged
> sys_epoll_pwait without it anyway -- despite the fact that it's
> include/linux/eventpoll.h which contains the example of why we should
> think first :)
> 
> I think I even threw together an untested implementation of
> compat_sys_epoll_pwait() at one point to assist with that task, but it
> didn't seem to help much.

Damn! I always forget. Doing it right now ...


- Davide


