Return-Path: <linux-kernel-owner+w=401wt.eu-S1756350AbZANKph@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756350AbZANKph (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 05:45:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752657AbZANKp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 05:45:28 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47018
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752580AbZANKp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 05:45:27 -0500
Date: Wed, 14 Jan 2009 02:45:28 -0800 (PST)
Message-Id: <20090114.024528.80563421.davem@davemloft.net>
To: Jesper.Nilsson@axis.com
Cc: roucaries.bastien@gmail.com, linux-kernel@vger.kernel.org, tj@kernel.org,
       gregkh@suse.de, stern@rowland.harvard.edu, jens.axboe@oracle.com,
       hinko.kocevar@cetrtapot.si
Subject: Re: lib/klist.c: bit 0 in pointer can't be used as flag
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090114103624.GH19262@axis.com>
References: <20090114101908.GF19262@axis.com>
	<20090114.022140.169499153.davem@davemloft.net>
	<20090114103624.GH19262@axis.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesper Nilsson <Jesper.Nilsson@axis.com>
Date: Wed, 14 Jan 2009 11:36:24 +0100

> On Wed, Jan 14, 2009 at 11:21:40AM +0100, David Miller wrote:
> > From: Jesper Nilsson <Jesper.Nilsson@axis.com>
> > Date: Wed, 14 Jan 2009 11:19:08 +0100
> > > The following patch works for CRIS, and is less intrusive than
> > > my earlier patch. If this the way to go I can resubmit a proper patch.
> > 
> > Out of curiosity, is there a way to get gcc to output code such
> > that data objects are aligned more naturally?  Some option or
> > similar?
> 
> There's flags for alignment of objects, but no flags for changing
> structure layout or size, which is probably what we run into here.

Really?

I thought the problem is that the base object can have any odd
alignment in the kernel image.  And this is why the problem isn't run
into for objects allocated using dynamic allocation.

