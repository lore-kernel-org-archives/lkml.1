Return-Path: <linux-kernel-owner+w=401wt.eu-S1756513AbZJBTPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756513AbZJBTPp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 15:15:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754141AbZJBTPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 15:15:44 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:1982 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753891AbZJBTPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 15:15:43 -0400
Date: Fri, 2 Oct 2009 14:16:26 -0500
From: Mike Miller <mike.miller@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>,
       James.Bottomley@HansenPartnership.com, axboe@kernel.dk,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       mikem@beardog.cce.hp.com, jowens@hp.com, mike.miller@hp.com
Subject: Re: [PATCH] Add hpsa driver for HP Smart Array controllers.
Message-ID: <20091002191626.GA17862@beardog.cce.hp.com>
References: <20091001211705.15591.76403.stgit@beardog.cce.hp.com> <20091001143035.a83a7564.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091001143035.a83a7564.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 01, 2009 at 02:30:35PM -0700, Andrew Morton wrote:
> On Thu, 01 Oct 2009 16:25:30 -0500
> "Stephen M. Cameron" <scameron@beardog.cce.hp.com> wrote:
> 
> > Add hpsa driver for HP Smart Array controllers.
> > 
> > This driver supports a subset of HP Smart Array Controllers.
> > It is a SCSI alternative to the cciss driver.
> 
> Does it support all the devices which cciss supports?
> 
> IOW, do we have a plan here to remove the cciss driver or must we
> maintain both drivers indefinitely?

Andrew, et al.,
>From the lack of response I'm guessing my reply about phasing cciss out
completely did not go over well. Or is that what the question meant?

We purposely limited controller support in hpsa to try and prevent problems
in the field. What's needed to get hpsa accepted? Add support for all
hardware?

While we do not want to maintain 2 drivers indefinitely we (HP) must
continue to support cciss for some years to come.

Any guidance is appreciated.

-- mikem
