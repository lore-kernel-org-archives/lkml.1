Return-Path: <linux-kernel-owner+w=401wt.eu-S1755867AbZHWHcm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755867AbZHWHcm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 03:32:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755809AbZHWHcl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 03:32:41 -0400
Received: from hera.cwi.nl ([192.16.191.8]:62114 "EHLO hera.cwi.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755771AbZHWHcl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 03:32:41 -0400
Date: Sun, 23 Aug 2009 09:36:33 +0200
From: "Andries E. Brouwer" <Andries.Brouwer@cwi.nl>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: "Andries E. Brouwer" <Andries.Brouwer@cwi.nl>,
       linux-kernel@vger.kernel.org
Subject: Re: completely hide parts of the partition table from Windows?
Message-ID: <20090823073632.GA31303@ub>
References: <19083.7062.710265.941247@pilspetsen.it.uu.se> <20090818223522.GA5872@ub> <19083.16290.445891.283072@pilspetsen.it.uu.se> <19088.30773.367549.73131@pilspetsen.it.uu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19088.30773.367549.73131@pilspetsen.it.uu.se>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 23, 2009 at 12:59:01AM +0200, Mikael Pettersson wrote:

>  >  > Make a table that has a Linux extended partition (type 85)
>  >  > that is short enough not to cause Windows to worry. Have logical
>  >  > partitions inside of any size and location you desire.
> 
> The problem here is that both fdisk and parted refuse to let me
> create a logical partition that exceeds the boundaries of the
> enclosing extended partition entry. So for this approach I'd have
> to find another Linux partitioning tool, or hack e.g. fdisk to
> bypass its safety checks (which do make sense for most use cases,
> just not for mine).

My plan would be (i) create the right logical partitions
(inside a sufficiently large extended one) using any partitioner.
(ii) change the type and size of the outer extended partition only,
for example using sfdisk. The -N option can be used to tell sfdisk
to change only a single partition entry.

Andries

