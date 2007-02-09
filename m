Return-Path: <linux-kernel-owner+w=401wt.eu-S1752436AbXBIV7K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752436AbXBIV7K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 16:59:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752449AbXBIV7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 16:59:10 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:48176 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436AbXBIV7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 16:59:09 -0500
Subject: Re: -mm merge plans for 2.6.21
From: David Woodhouse <dwmw2@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexey Dobriyan <adobriyan@openvz.org>, linux-kernel@vger.kernel.org,
       drepper@redhat.com, Davide Libenzi <davidel@xmailserver.org>
In-Reply-To: <20070209134516.2367a7aa.akpm@linux-foundation.org>
References: <20070208150710.1324f6b4.akpm@linux-foundation.org>
	 <1171042535.29713.96.camel@pmac.infradead.org>
	 <20070209134516.2367a7aa.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 09 Feb 2007 21:59:02 +0000
Message-Id: <1171058342.29713.136.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-02-09 at 13:45 -0800, Andrew Morton wrote:
> > I would strongly recommend that in the general case, you don't merge new
> > system calls unless the corresponding compat_ system call is
> > implemented.
> 
> Good point. 

It's a _damn_ good point, but I see we went ahead and merged
sys_epoll_pwait without it anyway -- despite the fact that it's
include/linux/eventpoll.h which contains the example of why we should
think first :)

I think I even threw together an untested implementation of
compat_sys_epoll_pwait() at one point to assist with that task, but it
didn't seem to help much.

-- 
dwmw2

