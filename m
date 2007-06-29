Return-Path: <linux-kernel-owner+w=401wt.eu-S1756511AbXF2Uwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756511AbXF2Uwt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 16:52:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754707AbXF2Uwk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 16:52:40 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41419 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754871AbXF2Uwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 16:52:39 -0400
Date: Fri, 29 Jun 2007 13:51:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Alexey Dobriyan <adobriyan@sw.ru>, dhowells@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] frv: fix fallout from "remove sched.h from mm.h" patch
Message-Id: <20070629135130.cf977168.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0706290904420.13877@localhost.localdomain>
References: <20070628140921.GA9753@localhost.sw.ru>
	<20070628151257.7a03e81b.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0706290904420.13877@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Jun 2007 09:10:52 -0400 (EDT)
"Robert P. J. Day" <rpjday@mindspring.com> wrote:

> > Please provide changelogs.
> >
> > I assume this patch fixes some build error or something.

I am still awaiting a description of what this patch does.

>   i actually asked about this on either the janitors or newbies list
> the other day -- one of the early examples from the LDD3 device
> drivers book which built fine all this time suddenly stopped building,
> until i explicitly included <linux/sched.h> to be able to dereference
> a pointer to "task_struct":
> 
> /home/rpjday/AMD/k/topics/0_hi/hi1.c:15: error: dereferencing pointer to incomplete type
> /home/rpjday/AMD/k/topics/0_hi/hi1.c:16: error: dereferencing pointer to incomplete type

I'll proceed, assuming that the patch fixes the above build errors.
