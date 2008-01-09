Return-Path: <linux-kernel-owner+w=401wt.eu-S1754976AbYAIMbO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976AbYAIMbO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 07:31:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752868AbYAIMbA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 07:31:00 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:49949 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752383AbYAIMa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 07:30:59 -0500
Date: Wed, 9 Jan 2008 07:30:28 -0500
From: Theodore Tso <tytso@MIT.EDU>
To: Matthias Schniedermeyer <ms@citd.de>
Cc: Tuomo Valkonen <tuomov@iki.fi>, linux-kernel@vger.kernel.org
Subject: Re: The ext3 way of journalling
Message-ID: <20080109123028.GM21097@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Matthias Schniedermeyer <ms@citd.de>,
	Tuomo Valkonen <tuomov@iki.fi>, linux-kernel@vger.kernel.org
References: <slrnfo77tv.2rr.tuomov@jolt.modeemi.cs.tut.fi> <20080108164847.GA16462@skl-net.de> <slrnfo7e3i.c37.tuomov@jolt.modeemi.cs.tut.fi> <20080108230600.GA9071@citd.de> <20080109075658.GA29920@jolt.modeemi.cs.tut.fi> <20080109102139.GA14012@citd.de> <20080109102821.GA14085@citd.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080109102821.GA14085@citd.de>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2008 at 11:28:21AM +0100, Matthias Schniedermeyer wrote:
> On 09.01.2008 11:21, Matthias Schniedermeyer wrote:
> > On 09.01.2008 09:56, Tuomo Valkonen wrote:
> > > On 2008-01-09 00:06 +0100, Matthias Schniedermeyer wrote:
> > > > That what LABEL und UUID-Support in mount is for.
> > > 
> > > That's udev shit. I don't want it.
> > 
> > No.
> 
> To be more verbose.
> 
> The 'LABEL=' is native mount turf and is much older than udev.

Native fsck supports it to; "LABEL=" and "UUID=" support has been in
e2fsprogs since July 3rd, 1999.  (Mount had it a little before then,
but you needed both mount and fsck support before the feature could be
used.)

And it has *nothing* to do with udev....

					- Ted
