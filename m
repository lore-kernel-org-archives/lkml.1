Return-Path: <linux-kernel-owner+w=401wt.eu-S1756251AbXKEMus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251AbXKEMus (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 07:50:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754859AbXKEMuk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 07:50:40 -0500
Received: from brick.kernel.dk ([87.55.233.238]:4776 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754560AbXKEMuj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 07:50:39 -0500
Date: Mon, 5 Nov 2007 13:47:11 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: linux-kernel@vger.kernel.org, jeff@garzik.org, linux-ide@vger.kernel.org
Subject: Re: Suspend to ram regression (2.6.24-rc1-git)
Message-ID: <20071105124711.GF5359@kernel.dk>
References: <20071031201308.GK11514@kernel.dk> <20071101084145.GA5037@kernel.dk> <20071102163708.15304989.kristen.c.accardi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071102163708.15304989.kristen.c.accardi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 02 2007, Kristen Carlson Accardi wrote:
> On Thu, 1 Nov 2007 09:41:46 +0100
> Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > On Wed, Oct 31 2007, Jens Axboe wrote:
> > > Hi,
> > > 
> > > My x60 stopped suspending about two days ago. It just freezes after
> > > printing
> > > 
> > > Suspending console(s)
> > > 
> > > where it would normally turn everything off and the 'moon' light would
> > > go on. Posting this message in case somebody else knows what is up, if
> > > not I'll do a bisect on it tomorrow.
> > 
> > Did the bisect, it points to this commit:
> > 
> > 1556594f913fa81d008cecfe46d7211c919a853 is first bad commit
> > commit 31556594f913fa81d008cecfe46d7211c919a853
> > Author: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
> > Date:   Thu Oct 25 01:33:26 2007 -0400
> > 
> >     [libata] AHCI: add hw link power management support
> > 
> > Booting any kernel after this commit fails suspending to ram, it just
> > sits there forever.
> > 
> > -- 
> > Jens Axboe
> > 
> 
> Does this patch fix your problem?  It seems to get hung up while disabling
> DIPM, and after thinking about this a bit, I don't think we really need
> to do this anyway.

Yep, works for me! Can we get this expedited upstream?

-- 
Jens Axboe

