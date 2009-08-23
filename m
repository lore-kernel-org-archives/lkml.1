Return-Path: <linux-kernel-owner+w=401wt.eu-S933785AbZHWPTO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933785AbZHWPTO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 11:19:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933689AbZHWPTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 11:19:13 -0400
Received: from aun.it.uu.se ([130.238.12.36]:47389 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933675AbZHWPTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 11:19:13 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19089.24045.354367.108579@pilspetsen.it.uu.se>
Date: Sun, 23 Aug 2009 17:19:09 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: "Andries E. Brouwer" <Andries.Brouwer@cwi.nl>
Cc: Mikael Pettersson <mikpe@it.uu.se>, linux-kernel@vger.kernel.org
Subject: Re: completely hide parts of the partition table from Windows?
In-Reply-To: <20090823073632.GA31303@ub>
References: <19083.7062.710265.941247@pilspetsen.it.uu.se>
	<20090818223522.GA5872@ub>
	<19083.16290.445891.283072@pilspetsen.it.uu.se>
	<19088.30773.367549.73131@pilspetsen.it.uu.se>
	<20090823073632.GA31303@ub>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andries E. Brouwer writes:
 > On Sun, Aug 23, 2009 at 12:59:01AM +0200, Mikael Pettersson wrote:
 > 
 > >  >  > Make a table that has a Linux extended partition (type 85)
 > >  >  > that is short enough not to cause Windows to worry. Have logical
 > >  >  > partitions inside of any size and location you desire.
 > > 
 > > The problem here is that both fdisk and parted refuse to let me
 > > create a logical partition that exceeds the boundaries of the
 > > enclosing extended partition entry. So for this approach I'd have
 > > to find another Linux partitioning tool, or hack e.g. fdisk to
 > > bypass its safety checks (which do make sense for most use cases,
 > > just not for mine).
 > 
 > My plan would be (i) create the right logical partitions
 > (inside a sufficiently large extended one) using any partitioner.
 > (ii) change the type and size of the outer extended partition only,
 > for example using sfdisk. The -N option can be used to tell sfdisk
 > to change only a single partition entry.

Thanks, sfdisk did the trick.

/Mikael
