Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933440Ab0BDXqs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 18:46:48 -0500
Received: from straum.hexapodia.org ([64.81.70.185]:47113 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932660Ab0BDXqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 18:46:47 -0500
Date: Thu, 4 Feb 2010 15:46:46 -0800
From: Andy Isaacson <adi@hexapodia.org>
To: Paolo Ornati <ornati@fastwebnet.it>
Cc: Nick Bowler <nbowler@elliptictech.com>, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [BISECTED] post -rc6 regression, X server crash.
Message-ID: <20100204234646.GB28286@hexapodia.org>
References: <20100204143630.GA18161@emergent.ellipticsemi.com> <20100204204536.3316dff0@fastwebnet.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100204204536.3316dff0@fastwebnet.it>
User-Agent: Mutt/1.4.2.3i
X-GPG-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-GPG-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 04, 2010 at 08:45:36PM +0100, Paolo Ornati wrote:
> On Thu, 4 Feb 2010 09:36:30 -0500
> Nick Bowler <nbowler@elliptictech.com> wrote:
> > I'm using Intel KMS with xf86-video-intel 2.10.0.  I bisected the issue
> > to the following commit.  Reverting the commit allows Xorg to start
> > again.
> > 
> > 859ddf09743a8cc680af33f7259ccd0fd36bfe9d is the first bad commit
> > commit 859ddf09743a8cc680af33f7259ccd0fd36bfe9d
> > Author: Tejun Heo <tj@kernel.org>
> > Date:   Tue Feb 2 13:43:58 2010 -0800
> > 
> >     idr: fix a critical misallocation bug
> 
> Me too, with different chipset and driver version.
> 
> Reverting that commit fixes the problem for me.

Previously reported at
http://lkml.org/lkml/2010/2/3/415
and
http://lkml.org/lkml/2010/2/3/463

and Tejun sent the revert upstream:
http://lkml.org/lkml/2010/2/4/75

-andy
