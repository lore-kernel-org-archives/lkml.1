Return-Path: <linux-kernel-owner+w=401wt.eu-S1755129AbXDZVXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129AbXDZVXQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 17:23:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755132AbXDZVXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 17:23:16 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:60783 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755128AbXDZVXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 17:23:15 -0400
Date: Thu, 26 Apr 2007 14:22:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Dan Williams <dan.j.williams@intel.com>
Subject: Re: W1 printk format warning
Message-Id: <20070426142226.891d2e9a.akpm@linux-foundation.org>
In-Reply-To: <20070426181743.GA3552@2ka.mipt.ru>
References: <20070425162104.168c32b6.randy.dunlap@oracle.com>
	<20070425164509.715ca5c9.akpm@linux-foundation.org>
	<20070426181743.GA3552@2ka.mipt.ru>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Apr 2007 22:17:44 +0400 Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:

> On Wed, Apr 25, 2007 at 04:45:09PM -0700, Andrew Morton (akpm@linux-foundation.org) wrote:
> > On Wed, 25 Apr 2007 16:21:04 -0700 Randy Dunlap <randy.dunlap@oracle.com> wrote:
> > 
> > > in 2.6.21-rc7-mm1.  Are you aware of this?
> > > 
> > > drivers/w1/w1.c:460: warning: too few arguments for format
> > > 
> > > 	dev_dbg(&sl->dev, "%s: registering %s as %p.\n", __func__,
> > > 		&sl->dev.bus_id[0]);
> > > 
> > 
> > Yeah, that's because Dan's dev_dbg-check-dev_dbg-arguments.patch added
> > printk arg-checking to dev_dbg() and a bunch of bugs got exposed.  I fixed
> > a few of them.
> 
> Could you post a full list for w1, if there is only one, here is a fix.
> 

There's only the one in w1, I think.  I fixed a few more but I didn't
actually go looking for more such errors.

