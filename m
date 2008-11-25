Return-Path: <linux-kernel-owner+w=401wt.eu-S1754233AbYKYVz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233AbYKYVz1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 16:55:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752716AbYKYVzN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 16:55:13 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50254 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752322AbYKYVzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 16:55:12 -0500
Date: Tue, 25 Nov 2008 13:54:17 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, rostedt@goodmis.org
Subject: Re: mmotm 2008-11-24-16-52 uploaded (trace)
Message-Id: <20081125135417.d86fc057.akpm@linux-foundation.org>
In-Reply-To: <492C6F8E.5080207@oracle.com>
References: <200811250052.mAP0qxAQ005254@imap1.linux-foundation.org>
	<492C6F8E.5080207@oracle.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Nov 2008 13:35:10 -0800
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> akpm@linux-foundation.org wrote:
> > The mm-of-the-moment snapshot 2008-11-24-16-52 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> 
> All of my i386 builds end with:
> 
> kernel/trace/ring_buffer.c:342: error: 'buffer' undeclared (first use in this function)
> kernel/trace/ring_buffer.c:342: error: (Each ndeclared identifier is reported only once
> kernel/trace/ring_buffer.c:342: error: for each function it appears in.)
> make[3]: *** [kernel/trace/ring_buffer.o] Error 1
> 

Thanks, that's bustage in my tree.  trace-add-missing-mutex_unlock.patch
gets applied at line 306 then gets removed from line 617.  Sigh, it
happens sometimes.  Latest mmotm fixes that.




