Return-Path: <linux-kernel-owner+w=401wt.eu-S935736AbYBHSM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935736AbYBHSM2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 13:12:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761506AbYBHSMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 13:12:06 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50181 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756820AbYBHSMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 13:12:02 -0500
Date: Fri, 8 Feb 2008 10:11:51 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Paul Clements <paul.clements@steeleye.com>, linux-kernel@vger.kernel.org,
       nbd-general@lists.sourceforge.net, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 1/1] NBD: make nbd default to deadline I/O scheduler
Message-Id: <20080208101151.935b575c.akpm@linux-foundation.org>
In-Reply-To: <20080208093341.b4d02e22.randy.dunlap@oracle.com>
References: <47AC87AE.9040408@steeleye.com>
	<20080208093341.b4d02e22.randy.dunlap@oracle.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Feb 2008 09:33:41 -0800 Randy Dunlap <randy.dunlap@oracle.com> wrote:

> On Fri, 08 Feb 2008 11:47:42 -0500 Paul Clements wrote:
> 
> > There have been numerous reports of problems with nbd and cfq. Deadline 
> > gives better performance for nbd, anyway, so let's use it by default.

Please define "problems".  If it's just "slowness" then we can live with
that, but I'd hope that Jens is aware and that it's understood.

It it's "hangs" or "oopses" then we panic.

> so what happens with this patch on cfq-only or as-only kernels?

I assume the elevator_init() call fails and the default elevator continues
to be used.  Perhaps an informative printk is needed.

