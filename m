Return-Path: <linux-kernel-owner+w=401wt.eu-S1762794AbXJYUl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762794AbXJYUl2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 16:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755922AbXJYUlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 16:41:05 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32797 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753301AbXJYUlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 16:41:00 -0400
Date: Thu, 25 Oct 2007 13:40:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: rmk+lkml@arm.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-serial@vger.kernel.org
Subject: Re: [PATCH] serial: do not call ->pm() on initialization for
 console port
Message-Id: <20071025134044.58ca9d35.akpm@linux-foundation.org>
In-Reply-To: <20071026.010510.59032545.anemo@mba.ocn.ne.jp>
References: <20071019.011355.39154656.anemo@mba.ocn.ne.jp>
	<20071018161827.GB16244@flint.arm.linux.org.uk>
	<20071026.010510.59032545.anemo@mba.ocn.ne.jp>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Oct 2007 01:05:10 +0900 (JST)
Atsushi Nemoto <anemo@mba.ocn.ne.jp> wrote:

> On Thu, 18 Oct 2007 17:18:27 +0100, Russell King <rmk+lkml@arm.linux.org.uk> wrote:
> > > Attached patch fixes this problem.  Is this a right way?
> > > If not, I will fix the serial_txx9 driver to skip the initialization in
> > > ->pm() if oldstate was -1.
> > 
> > I'll have to investigate further to refresh myself with what's going
> > on here, but your patch looks wrong.
> 
> Now rc1 is released.  Any chances for this patch?
> If none, I should push other workaround to fix this issue on 2.6.24.

I don't know what patch you're referring to.  I don't appear to have
whatever-patch-this-is queued up anywhere?
