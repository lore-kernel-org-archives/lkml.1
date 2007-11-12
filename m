Return-Path: <linux-kernel-owner+w=401wt.eu-S1759518AbXKLWOI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759518AbXKLWOI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 17:14:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756478AbXKLWN4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 17:13:56 -0500
Received: from mail.fieldses.org ([66.93.2.214]:38552 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755650AbXKLWN4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 17:13:56 -0500
Date: Mon, 12 Nov 2007 17:13:49 -0500
To: Neil Brown <neilb@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, nfs@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: nfsd bugfixes
Message-ID: <20071112221349.GA2645@fieldses.org>
References: <1194901503-23105-1-git-send-email-bfields@citi.umich.edu> <18232.52970.213438.902011@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18232.52970.213438.902011@notabene.brown>
User-Agent: Mutt/1.5.17 (2007-11-01)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2007 at 09:08:42AM +1100, Neil Brown wrote:
> On Monday November 12, bfields@citi.umich.edu wrote:
> > The following two patches are nfsd bugfixes that I believe are
> > appropriate for 2.6.24 and 2.6.23.y.
> > 
> > --b.
> > 
> 
> Both
>   Reviewed-By: NeilBrown <neilb@suse.de>

Thanks, Neil.

> Calling nfsd_setuser an extra time does open us up for a very tiny
> possibility of an ENOMEM at an awkward time.

Hm.  Could you give an example of possible consequences?

(Though note this is somewhat of a separate discussion, since this
particular patch doesn't add a call to nfsd_setuser().)

> We could remove that entirely for NFSEXP_ALLSQUASH by allocating an
> empty group_info at export time and just using a reference to that.
> It would be more awkward to pre-allocate for the NFSEXP_ROOTSQUASH
> case as the group_info has to be at least as big as the one in the RPC
> request, and would could need a different one of each concurrent
> request.... not sure if that is worth "fixing".

--b.
