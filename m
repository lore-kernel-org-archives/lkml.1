Return-Path: <linux-kernel-owner+w=401wt.eu-S1753630AbYLAUDQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630AbYLAUDQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 15:03:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752523AbYLAUC7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 15:02:59 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60119 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752251AbYLAUC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 15:02:58 -0500
Date: Mon, 1 Dec 2008 12:02:10 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Matt Mackall <mpm@selenic.com>
Cc: randy.dunlap@oracle.com, greg@kroah.com, adobriyan@gmail.com,
       remi.colinet@gmail.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, linux-api@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [RESEND][PATCH] Add /proc/mempool to display mempool usage
Message-Id: <20081201120210.1ed16bd5.akpm@linux-foundation.org>
In-Reply-To: <1228158811.3196.88.camel@calx>
References: <1227980689.6354.24.camel@localhost.localdomain>
	<20081129214207.GA6747@x200.localdomain>
	<20081129234907.GA2340@kroah.com>
	<20081201101245.0a2f3123.randy.dunlap@oracle.com>
	<1228158811.3196.88.camel@calx>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 01 Dec 2008 13:13:31 -0600
Matt Mackall <mpm@selenic.com> wrote:

> On Mon, 2008-12-01 at 10:12 -0800, Randy Dunlap wrote:
> > On Sat, 29 Nov 2008 15:49:07 -0800 Greg KH wrote:
> > 
> > > On Sun, Nov 30, 2008 at 12:42:07AM +0300, Alexey Dobriyan wrote:
> > > > On Sat, Nov 29, 2008 at 06:44:49PM +0100, Remi Colinet wrote:
> > > > > This patch add a new /proc/mempool file in order to display mempool usage.
> > > > > 
> > > > > The feature can be disabled with CONFIG_PROC_MEMPOOL=N during kernel
> > > > > configuration.
> > > > 
> > > > We're NOT adding config option per proc file.
> > > > 
> > > > And can we, please, freeze /proc for not per-process stuff and open debugfs
> > > > for random stuff, please?
> > > 
> > > debugfs has been open for random stuff since the day it was added to the
> > > tree :)
> > > 
> > > Feel free to put this kind of thing there instead of proc.
> > 
> > Do distros ship with debugfs enabled?
> > The problem with using debugfs is that it is very optional IMO.
> 
> The problem with debugfs is that it claims to not be an ABI but it is
> lying. Distributions ship tools that depend on portions of debugfs. And
> they also ship debugfs in their kernel. So it is effectively the same
> as /proc, except with the 1.0-era everything-goes attitude rather than
> the 2.6-era we-should-really-think-about-this one.
> 
> Pushing stuff from procfs to debugfs is thus just setting us up for pain
> down the road. Don't do it. In five years, we'll discover we can't turn
> debugfs off or even clean it up because too much relies on it.
> 
> If you think that debugfs is NOT an ABI, then I'm sure you'll be happy
> to ack my patch entitled 'gratuitously break usbmon to remind folks that
> debugfs is not an ABI'.

^^ yup.
