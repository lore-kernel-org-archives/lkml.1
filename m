Return-Path: <linux-kernel-owner+w=401wt.eu-S1751901AbXB1UJI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751901AbXB1UJI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 15:09:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751900AbXB1UJI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 15:09:08 -0500
Received: from mail.screens.ru ([213.234.233.54]:50177 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751901AbXB1UJH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 15:09:07 -0500
Date: Wed, 28 Feb 2007 23:08:53 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: vatsa@in.ibm.com, Pavel Machek <pavel@ucw.cz>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Problem with freezable workqueues
Message-ID: <20070228200853.GA122@tv-sign.ru>
References: <200702272251.28844.rjw@sisk.pl> <200702282017.39752.rjw@sisk.pl> <20070228193234.GA86@tv-sign.ru> <200702282043.24779.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702282043.24779.rjw@sisk.pl>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28, Rafael J. Wysocki wrote:
>
> On Wednesday, 28 February 2007 20:32, Oleg Nesterov wrote:
> > 
> > I am sorry, I lost track of this problem. As for 2.6.21, create_freezeable_workqueue
> > doesn't work and conflict with suspend. Why can't we remove it from XFS as you
> > suggested before?
> 
> Yes, we can (preparing a patch).  I was just curious. :-)

OK, thanks.

We can (I think) do pretty much the same with some additional complications
in worker_thread() (check !cpu_online() after try_to_freeze() and break).

Oleg.

