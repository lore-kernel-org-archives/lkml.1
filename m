Return-Path: <linux-kernel-owner+w=401wt.eu-S1758006AbXERWPs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758006AbXERWPs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 18:15:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755142AbXERWPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 18:15:41 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47402 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755123AbXERWPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 18:15:41 -0400
Date: Fri, 18 May 2007 15:12:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Phillip Susi <psusi@cfl.rr.com>
Cc: Alex Volkov <avcp-lkmail@usa.net>, "'Jeff Garzik'" <jeff@garzik.org>,
       "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>
Subject: Re: aio is unlikely
Message-Id: <20070518151259.319e09da.akpm@linux-foundation.org>
In-Reply-To: <464E2098.8020900@cfl.rr.com>
References: <20070509151831.f5956b66.akpm@linux-foundation.org>
	<058f01c7998e$1406e370$650df7cd@MUMBA>
	<20070518140624.1a4db517.akpm@linux-foundation.org>
	<464E2098.8020900@cfl.rr.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 May 2007 17:54:32 -0400
Phillip Susi <psusi@cfl.rr.com> wrote:

> Andrew Morton wrote:
> > Yes, if you agree with Jeff's original point.
> > 
> > But I don't, actually.  Sure, on some machines+workloads, AIO is more
> > common than sync IO.  But I expect that when we sum across all the
> > machines+workloads in the world, sync IO is more common and is hence the
> > case we should optimise for.
> > 
> > That's assuming that the unlikely() actually does something.
> 
> But as Jeff said, that's not what unlikely is for.  It should only be 
> used when it is unlikely for everybody, all the time, because when it is 
> right, it helps rather little, but when it is wrong, it hurts a lot.

It does?  Tell us more.
