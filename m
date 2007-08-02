Return-Path: <linux-kernel-owner+w=401wt.eu-S1758829AbXHBSPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758829AbXHBSPq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 14:15:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754722AbXHBSPj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 14:15:39 -0400
Received: from SMTP.andrew.cmu.edu ([128.2.10.85]:52471 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755325AbXHBSPi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 14:15:38 -0400
From: Jeremy Maitin-Shepard <jbms@cmu.edu>
To: linux-kernel@vger.kernel.org
Subject: Re: [RFC 12/26] ext2 white-out support
References: <20070730161323.100048969@weierstrass.suse.de>
	<20070730161324.261652101@weierstrass.suse.de>
	<20070731163656.GC22350@filer.fsl.cs.sunysb.edu>
	<20070731170012.GN5101@hasse.suse.de>
	<20070731171159.GA27234@filer.fsl.cs.sunysb.edu>
	<1185981810.18007.14.camel@kleikamp.austin.ibm.com>
	<20070801184405.GA18405@filer.fsl.cs.sunysb.edu>
	<1185995431.18007.24.camel@kleikamp.austin.ibm.com>
	<20070801193330.GA20928@filer.fsl.cs.sunysb.edu>
	<20070802175008.GA12627@lazybastard.org>
X-Habeas-SWE-9: mark in spam to <http://www.habeas.com/report/>.
X-Habeas-SWE-8: Message (HCM) and not spam. Please report use of this
X-Habeas-SWE-7: warrant mark warrants that this is a Habeas Compliant
X-Habeas-SWE-6: email in exchange for a license for this Habeas
X-Habeas-SWE-5: Sender Warranted Email (SWE) (tm). The sender of this
X-Habeas-SWE-4: Copyright 2002 Habeas (tm)
X-Habeas-SWE-3: like Habeas SWE (tm)
X-Habeas-SWE-2: brightly anticipated
X-Habeas-SWE-1: winter into spring
Date: Thu, 02 Aug 2007 14:15:35 -0400
In-Reply-To: <20070802175008.GA12627@lazybastard.org> (=?utf-8?Q?=22J?=
 =?utf-8?Q?=C3=B6rn?= Engel"'s message
	of "Thu\, 2 Aug 2007 19\:50\:09 +0200")
Message-ID: <878x8tkdko.fsf@jbms.ath.cx>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jörn Engel <joern@logfs.org> writes:

> On Wed, 1 August 2007 15:33:30 -0400, Josef Sipek wrote:
>> 
>> This brings up an very interesting (but painful) question...which makes more
>> sense? Allowing the modifications in only the top-most branch, or any branch
>> (given the user allows it at mount-time)?
>> 
>> This is really question to the community at large, not just you, Dave :)

> Only write to top-most layer.

> There are two reasons for this.  First it allows users to create a union
> mount, test something (e.g. update the distribution) and remove every
> trace from the test by umounting the top-most layer.  Such a thing can
> be quite valuable.

Josef did specifically state that modification to the lower layers would
be allowed only if a special mount flag is given.

> The second reason is simplicity.  I personally couldn't even start to
> describe the semantics.  If the user does a rename, which layer will the
> change end up in?  What if source or target exist in multiple layers?
> How to rename a directory in a lower layer containing a new file in an
> upper layer?

> Finding new and interesting corner cases for such a beast can be quite
> entertaining.  And until someone has properly documented the semantics
> for _all_ the corner cases, my enthusiasm is below freezing point.  Does
> such a documentation exist?

I think that if someone can come up with consistent (and useful)
semantics for a mount option that allows modifications to other layers
as well, it would be a useful additional feature to support.  It seems
that it should be possible to add this feature at a later time in any
case.

Perhaps referring to the plan9 semantics could be helpful.

-- 
Jeremy Maitin-Shepard
