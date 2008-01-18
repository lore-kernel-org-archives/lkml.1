Return-Path: <linux-kernel-owner+w=401wt.eu-S1761922AbYAROYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761922AbYAROYY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 09:24:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756944AbYAROYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 09:24:15 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:38230 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756796AbYAROYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 09:24:14 -0500
Date: Fri, 18 Jan 2008 09:23:08 -0500
From: Theodore Tso <tytso@MIT.EDU>
To: Bryan Henderson <hbryan@us.ibm.com>
Cc: Ric Wheeler <ric@emc.com>, Al Boldi <a1426z@gawab.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, David Chinner <dgc@sgi.com>,
       linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
       Daniel Phillips <phillips@google.com>, Rik van Riel <riel@redhat.com>,
       Valerie Henson <val.henson@gmail.com>
Subject: Re: [Patch] document ext3 requirements (was Re: [RFD] Incremental
	fsck)
Message-ID: <20080118142308.GD12796@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Bryan Henderson <hbryan@us.ibm.com>, Ric Wheeler <ric@emc.com>,
	Al Boldi <a1426z@gawab.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
	David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org,
	Pavel Machek <pavel@ucw.cz>, Daniel Phillips <phillips@google.com>,
	Rik van Riel <riel@redhat.com>,
	Valerie Henson <val.henson@gmail.com>
References: <478FE22D.9030907@emc.com> <OF3F61F02C.985CCACC-ON882573D4.0001DCF2-882573D4.0002E9F5@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OF3F61F02C.985CCACC-ON882573D4.0001DCF2-882573D4.0002E9F5@us.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2008 at 04:31:48PM -0800, Bryan Henderson wrote:
> But I heard some years ago from a disk drive engineer that that is a myth 
> just like the rotational energy thing.  I added that to the discussion, 
> but admitted that I haven't actually seen a disk drive write a partial 
> sector.

Well, it would be impossible or at least very hard to see that in
practice, right?  My understanding is that drives do sector-level
checksums, so if there was a partially written sector, the checksum
would be bogus and the drive would return an error when you tried to
read from it.

> Ted brought up the separate issue of the host sending garbage to the disk 
> device because its own power is failing at the same time, which makes the 
> integrity at the disk level moot (or even undesirable, as you'd rather 
> write a bad sector than a good one with the wrong data).

Yep, exactly.  It would be interesting to see if this happens on
modern hardware; all of the evidence I've had for this is years old at
this point.  

							- Ted
