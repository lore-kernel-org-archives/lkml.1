Return-Path: <linux-kernel-owner+w=401wt.eu-S1757642AbYILTJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757642AbYILTJ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 15:09:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757014AbYILTI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 15:08:58 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49735 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757476AbYILTI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 15:08:58 -0400
Date: Fri, 12 Sep 2008 09:46:29 -0700
From: Greg KH <greg@kroah.com>
To: Janne Grunau <j@jannau.net>
Cc: Andi Kleen <andi@firstfloor.org>, Jarod Wilson <jwilson@redhat.com>,
       linux-kernel@vger.kernel.org, Jarod Wilson <jarod@redhat.com>,
       Christoph Bartelmus <lirc@bartelmus.de>,
       Mario Limonciello <superm1@ubuntu.com>
Subject: Re: [PATCH 01/18] lirc core device driver infrastructure
Message-ID: <20080912164629.GA5094@kroah.com>
References: <1220933164-10160-1-git-send-email-jwilson@redhat.com> <200809091335.17559.j@jannau.net> <20080909130311.GA4085@one.firstfloor.org> <200809091520.35694.j@jannau.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809091520.35694.j@jannau.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2008 at 03:20:35PM +0200, Janne Grunau wrote:
> On Tuesday 09 September 2008 15:03:11 Andi Kleen wrote:
> > > pr_printk is not found in include/ nor by google. please explain
> >
> > pr_debug() sorry.
> 
> pr_debug() does something else. that dprintk macro prints depending on a 
> module parameter

pr_debug() is what you want, 2.6.28 will turn it into a dynamic option
to turn on and off at a per-module level.

Actually you should be using dev_dbg() instead, that's much better and
will also work the same way on a per-module level.

thanks,

greg k-h
