Return-Path: <linux-kernel-owner+w=401wt.eu-S1754036AbZB1MJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036AbZB1MJz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 07:09:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751896AbZB1MJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 07:09:47 -0500
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:32069 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751163AbZB1MJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 07:09:46 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=X0TAP+SmqtH7nMzWlRwhMbQJxolaNdDq4RsE/zVE7Wi2FyYXi/qHyaf4RDR8bPbFM+LJymQkUsqU9gL2nT491KPQTIbTa8efBfVBUfLg87/5+jyccioTBvkR8DXPCtR1/vyoJfMyIsKETD+zamlMgwVJXfWB4OT+pshMM77eG74=  ;
X-YMail-OSG: _uZz2OkVM1n7QNBYZmE.sAElhr9Ubc.KD5EDI.WD9BAqlYt42BaeBndEq4WTZr1GJZDj_xeSQ4UfG007_GokY6qvnkJcaC_ZWdr.8MDP9o1JRwJ2c4gCYx_4U.8In2Kp1LX3v0N6UEu22vbwfJVKAlNtW1bhmNN1RWbvRsw4W7xQdBioV9mis4LHQxlSHXuYMqwIF7olQk5KRBNYS_H6xqgtT084
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH] xen: core dom0 support
Date: Sat, 28 Feb 2009 23:09:07 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "the arch/x86 maintainers" <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Xen-devel" <xen-devel@lists.xensource.com>
References: <1235786365-17744-1-git-send-email-jeremy@goop.org> <20090227212812.26d02f34.akpm@linux-foundation.org> <49A8DF28.4050301@goop.org>
In-Reply-To: <49A8DF28.4050301@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902282309.07576.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 28 February 2009 17:52:24 Jeremy Fitzhardinge wrote:
> Andrew Morton wrote:

> > I hate to be the one to say it, but we should sit down and work out
> > whether it is justifiable to merge any of this into Linux.  I think
> > it's still the case that the Xen technology is the "old" way and that
> > the world is moving off in the "new" direction, KVM?
>
> I don't think that's a particularly useful way to look at it.  They're
> different approaches to the problem, and have different tradeoffs.
>
> The more important question is: are there real users for this stuff?
> Does not merging it cause more net disadvantage than merging it?
> Despite all the noise made about kvm in kernel circles, Xen has a large
> and growing installed base.  At the moment its all running on massive
> out-of-tree patches, which doesn't make anyone happy.  It's best that it
> be in the mainline kernel.  You know, like we argue for everything else.

OTOH, there are good reasons not to duplicate functionality, and many
many times throughout the kernel history competing solutions have been
rejected even though the same arguments could be made about them.

There have also been many times duplicate functionality has been merged,
although that does often start with the intention of eliminating
duplicate implementations and ends with pain. So I think Andrew's
question is pretty important.

The user issue aside -- that is a valid point -- you don't really touch
on the technical issues. What tradeoffs, and where Xen does better
than KVM would be interesting to know, can Xen tools and users ever be
migrated to KVM or vice versa (I know very little about this myself, so
I'm just an interested observer).

Ideally of course, consensus would be made that one or the other is the
better technical solution, and we should encourage developers to improve
that one and users to use it. Although obviously a consensus can't always
be made (usually when there is no right answer -- different tradeoffs
etc).

