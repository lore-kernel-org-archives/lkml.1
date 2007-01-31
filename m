Return-Path: <linux-kernel-owner+w=401wt.eu-S1752175AbXAaBIB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175AbXAaBIB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 20:08:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752178AbXAaBIB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 20:08:01 -0500
Received: from sj-iport-2-in.cisco.com ([171.71.176.71]:39149 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175AbXAaBIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 20:08:00 -0500
X-IronPort-AV: i="4.13,259,1167638400"; 
   d="scan'208"; a="358569884:sNHT49987352"
To: Jeff Garzik <jeff@garzik.org>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: Free Linux Driver Development!
X-Message-Flag: Warning: May contain useful information
References: <20070130012904.GA9617@kroah.com> <ada8xfks90x.fsf@cisco.com>
	<20070130191020.GF20642@kroah.com> <adaodogqpmx.fsf@cisco.com>
	<20070130195445.GE22022@kroah.com> <adazm80p4qp.fsf@cisco.com>
	<45BFC7F2.7090209@garzik.org> <adaac00p1rq.fsf@cisco.com>
	<45BFD03F.4020003@garzik.org> <adaps8wnlfl.fsf@cisco.com>
	<45BFDFE7.3000101@garzik.org>
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 30 Jan 2007 17:07:57 -0800
In-Reply-To: <45BFDFE7.3000101@garzik.org> (Jeff Garzik's message of "Tue, 30 Jan 2007 19:16:39 -0500")
Message-ID: <adaejpcnguq.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 31 Jan 2007 01:07:58.0400 (UTC) FILETIME=[3EFEF400:01C744D4]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > > To me, it's clear that historically the community hasn't delivered on
 > 
 > How is that clear?  As noted in the specific examples I provided, that
 > is how a large number of popular drivers and subsystems have been
 > developed.

Yes, I agree that it often works.  What I'm arguing is that it doesn't
ALWAYS work.  And Greg is promising (in effect, on my behalf) that "If
you give us specs, then we WILL have drivers."  As I've said several
times, I'm all for encouraging vendors to open specs.  The only thing
I don't like is marketing open specs by making promises that we may
not be able to keep.

 > The only difference between Greg's offer and offers made by other
 > developers to vendors is that his was public on LKML, and the subject
 > line concluded with an exclamation point.
 > 
 > I tell hardware vendors the same thing all the time -- just get the
 > specs to me or another capable developer, and we'll work with you to
 > get Linux support going.

There's a big difference, because Greg's offer goes to every vendor,
present and future, and promises a perfect driver in return for a spec
dump.  I have no problem with what you're telling vendors.  And I
think it's worth noting that you say, "we'll work with you to get
Linux support going."  You don't say, "all we need is specs to get
your driver into enterprise distros" -- you say that vendors need to
"work" with us, not just dump specs.

 > So far, we have ATA, USB, ethernet, audio, and several other positive
 > examples of this working in the real world.  And your
 > counter-examples? Ancient ISA drivers.

I think that's somewhat of a misrepresentation.  So far in this
thread, I've also raised Ralink wireless (stuck out-of-tree until
after the HW is EOLed) and USB Video Class (apparently also stuck out
of tree, in spite of vendor support from Logitech).  And Dave Airlie
mentioned XGI 3d HW.

Again, yes, I admit that releasing specs usually is the best way to
get Linux support.  Just don't promise (on my behalf) a perfectly
portable driver that will be maintained forever if only a vendor will
release specs.  Sometimes it works -- heck, usually it works -- as
long as there's a developer interested.

I think the message we should be sending is something more like:

  There are lots of people who are happy to write Linux drivers, given
  specs.  Releasing specs is the best, easiest way to get Linux
  support written at minimal cost.  The advantages to this for a
  hardware vendor are:
   - the driver is likely to be merged upstream, which has several
     benefits (continuing maintenance, distro inclusion, etc).
   - the driver is likely to be portable to any platform where the
     device physically has a chance at working.

  And we even have this new mechanism for managing specs that you can
  only release under NDA.

And that that last NDA management bit really is the big news, which
gets lost in the way Greg phrased things.  (I've buried the lede in my
message too -- someone with more marketing savvy should rewrite it)

 - R.
