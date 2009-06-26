Return-Path: <linux-kernel-owner+w=401wt.eu-S1759384AbZFZN16@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759384AbZFZN16 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 09:27:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756801AbZFZN1u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 09:27:50 -0400
Received: from brick.kernel.dk ([93.163.65.50]:33340 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754946AbZFZN1s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 09:27:48 -0400
Date: Fri, 26 Jun 2009 15:27:51 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: NeilBrown <neilb@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
       Mike Snitzer <snitzer@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alasdair G Kergon <agk@redhat.com>, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       device-mapper development <dm-devel@redhat.com>
Subject: Re: [dm-devel] REQUEST for new 'topology' metrics to be moved out
	of the 'queue' sysfs directory.
Message-ID: <20090626132751.GQ23611@kernel.dk>
References: <19010.62951.886231.96622@notabene.brown> <yq11vp8spxo.fsf@sermon.lab.mkp.net> <125b48b7ffc99a496fbdd512f38cada5.squirrel@neil.brown.name> <20090625194015.GB31415@kernel.dk> <19012.49673.454853.975682@notabene.brown> <20090626125037.GO23611@kernel.dk> <7c458f2470811a877dd60203b9bbb7ac.squirrel@neil.brown.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c458f2470811a877dd60203b9bbb7ac.squirrel@neil.brown.name>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 26 2009, NeilBrown wrote:
> On Fri, June 26, 2009 10:50 pm, Jens Axboe wrote:
> > On Fri, Jun 26 2009, Neil Brown wrote:
> 
> >> But for now, please please please can we revert the change which made
> >> 'queue' appear in md and dm devices, (and loop and ...) and put these
> >> generic values somewhere ... generic?
> >
> > No we cannot, not without a time machine. 2.6.30 is released, so it's
> > too late to revert things like that, even if we wanted.
> 
> Drat... for some reason I was thinking that it only came in in 2.6.31-rc.
> However it is only documented in ABI/testing, not ABI/stable ... if there
> is any value in that distinction, then it should be possible to move it??

The documentation doesn't really matter. The files are there and
released, so they cannot go away.

> Well, maybe I'm too late.
> If I send you a patch to remove all those fields in 'queue' that are not
> relevant to md/dm (when the queue is used for an md/dm device) would that
> be OK ??

What fields what that be? It's true that things like eg
max_hw_sectors_kb isn't strictly correct, but it still makes some sense
on pseudo-devices.

-- 
Jens Axboe

