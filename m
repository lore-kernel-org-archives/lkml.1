Return-Path: <linux-kernel-owner+w=401wt.eu-S1754357AbYFRP17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754357AbYFRP17 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 11:27:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752021AbYFRP1u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 11:27:50 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:52492 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751873AbYFRP1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 11:27:49 -0400
Subject: Request for discussion on when to merge drivers
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: ksummit-2008-discuss@lists.linux-foundation.org
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 18 Jun 2008 10:27:46 -0500
Message-Id: <1213802866.3515.24.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There have been a large number of emails on lkml (too many for me to
dredge up and quote) plus a fair few private ones on the subject of when
to merge drivers.  The opinions seem to vary from "immediately they show
up on the mailing list" to " after we're sure they're demonstrated to be
working and maintainable".  The fact that the arguments have been going
round and round on the various mailing lists without generating any
consensus would seem to indicate the topic would benefit from some face
to face discussion time.

I think the Kernel Summit would be a good place to have a discussion of
what the criteria are for merging a driver (even if, in the end, it's at
the discretion of the subsystem maintainers).

I think everyone agrees that we can't put just anything that appears on
the mailing list in the tree, since they all have to be at least code
inspected and be checked for the usual errors, omissions and root holes.
However, disagreements seem to set in after this.

For the record, my own view is that when a new driver does appear we
have a limited time to get the author to make any necessary changes, so
I try to get it reviewed and most of the major issues elucidated as soon
as possible.  However, since the only leverage I have is inclusion, I
tend to hold it out of tree until the problems are sorted out.
Experience has shown that for most SCSI drivers, the authors tend to be
the people producing the hardware and without documentation, no-one else
can fix up anything other than obvious coding errors, so we can't put it
in the tree and hope someone else will fix it if they have a problem.

One possible way of doing this is certainly to put the drivers in the
staging tree:

http://marc.info/?l=linux-kernel&m=121312896923196

The only slight wrinkle (at least for me) is that often the process of
cleaning up a driver is fairly intensive for a maintainer and turn
around is a lot faster if you're doing it in a tree you control.  (All
the scsi drivers we've done like this have lived in temporary branches
while they were being worked on).  So perhaps in addition we should be
encouraging maintainers to run staging branches under similar rules in
the staging tree, but allowing inclusion into linux-next?

James


