Return-Path: <linux-kernel-owner+w=401wt.eu-S1753701AbYCMGRj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701AbYCMGRj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 02:17:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751519AbYCMGRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 02:17:32 -0400
Received: from phunq.net ([64.81.85.152]:59490 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751468AbYCMGRb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 02:17:31 -0400
From: Daniel Phillips <phillips@phunq.net>
To: David Newall <davidn@davidnewall.com>
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Date: Wed, 12 Mar 2008 22:17:20 -0800
User-Agent: KMail/1.9.5
Cc: Chris Friesen <cfriesen@nortel.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org
References: <200803092346.17556.phillips@phunq.net> <200803121556.15547.phillips@phunq.net> <47D8BF76.8040105@davidnewall.com>
In-Reply-To: <47D8BF76.8040105@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803122317.24849.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 March 2008 22:45, David Newall wrote:
> Daniel Phillips wrote:
> > So you design for the number of nines you need, taking all factors
> > into account, and you design for the performance you need.  These are
> > cut and dried calculations.  FUD has no place here.
> 
> There's no FUD here.  The problem is that you didn't say that you've
> designed this for only a few nines.

Right.  6 or 7.

> If you delete fsck from your 
> rationale, simply saying that you rely on UPS to give you time to flush
> buffers, you have a much better story.  Certainly, once you've flushed
> buffers and degraded to write-through mode, you're obviously as reliable
> as ext2/3.

Fsck was never a part of my rationale.  Only reliability of components
was and is.  Then people jumped in saying Linux is too unreliable to
use in a, hmm, storage system.  Or transaction processing system.  Or
whatever.

Balderdash, I say.

> Your idea seems predicated on throwing large amounts of RAM at the
> problem.  What I want to know is this: Is it really 25 times faster than
> ext3 with an equally huge buffer cache?

Yes.

Regards,

Daniel
