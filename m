Return-Path: <linux-kernel-owner+w=401wt.eu-S1754109AbZBQXBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109AbZBQXBs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 18:01:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754088AbZBQXBL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 18:01:11 -0500
Received: from sov-mail-b0016.gradwell.net ([193.84.87.40]:51588 "EHLO
	sov-mail-b0016.gradwell.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753501AbZBQXBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 18:01:08 -0500
Date: Tue, 17 Feb 2009 22:59:46 +0000
From: Alex Buell <alex.buell@munted.org.uk>
To: Eric Sandeen <sandeen@redhat.com>
Cc: Theodore Tso <tytso@mit.edu>, Andres Freund <andres@anarazel.de>,
       adilger@sun.com, LKML <linux-kernel@vger.kernel.org>,
       linux-ext4@vger.kernel.org, Jonathan Bastien-Filiatrault <joe@x2a.org>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: EXT4 ENOSPC Bug
Message-ID: <20090217225946.053b8149@lithium.local.net>
In-Reply-To: <499B4097.90808@redhat.com>
References: <20090216162028.3032666a@lithium.local.net>
	<200811291418.24672.andres@anarazel.de>
	<200812100108.04163.andres@anarazel.de>
	<49994FEF.2020908@anarazel.de>
	<20090216150156.GD22619@mini-me.lan>
	<499985C7.8010302@anarazel.de>
	<20090216190001.GB11788@mini-me.lan>
	<499AFE32.7070003@redhat.com>
	<499B1935.10906@redhat.com>
	<20090217223017.3a86a045@lithium.local.net>
	<499B4097.90808@redhat.com>
Organization: One tortoiseshell cat, very high maintenance
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.12.11; i686-pc-linux-gnu)
X-Face: "wUuhsy:X)M;>-dA\j"&y@*\$91]iX10Iv1WG_oNbGYpo,eqc06O?"VSeRTx]xM\LiITUh01z}<|GF/4Gzz(MAU~;p4AS,%TB69M:vB-9+i'#W7$UQCW&UP#zt{VdLlzEiw8k~jL<
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Feb 2009 16:56:23 -0600, I waved a wand and this message
magically appears in front of Eric Sandeen:

> Alex Buell wrote:
> > On Tue, 17 Feb 2009 14:08:21 -0600, I waved a wand and this message
> > magically appears in front of Eric Sandeen:
> > 
> >> FWIW my problem seems to be different than others have encountered;
> >> mine persists past reboot, while other reporters have said that a
> >> reboot (remount) makes the problem go away.
> >>
> >> I seem to be encountering some silliness in find_group_flex when 2
> >> out of 3 groups are full (I "only" have 55k inodes left, all in
> >> the last group).
> > 
> > I've discovered a forced fsck clears this. HTH.
> 
> Do you have the output of the fsck run?

I'm afraid not, there's no way to save the output on a forced fsck
reboot.
-- 
http://www.munted.org.uk

Fearsome grindings.
