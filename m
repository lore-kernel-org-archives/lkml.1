Return-Path: <linux-kernel-owner+w=401wt.eu-S938215AbXHMNZL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938215AbXHMNZL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 09:25:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S971776AbXHMJUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 05:20:42 -0400
Received: from cantor.suse.de ([195.135.220.2]:54882 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S971768AbXHMJUj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 05:20:39 -0400
Date: Mon, 13 Aug 2007 11:20:36 +0200
From: Jan Blunck <jblunck@suse.de>
To: dm-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 05/11] dm-snap: remove SECTOR_SHIFT define
Message-ID: <20070813092036.GB12730@hasse.suse.de>
References: <20070810200204.455820246@suse.de>> <20070810200205.703776854@suse.de> <20070810203854.GG2064@agk.fab.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070810203854.GG2064@agk.fab.redhat.com>
Organization: SUSE LINUX Products GmbH, GF Markus Rex, HRB 16746 (AG
	Nuernberg)
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 10, Alasdair G Kergon wrote:

> On Fri, Aug 10, 2007 at 10:02:09PM +0200, Jan Blunck wrote:
> > Sector size on Linux is always 512 bytes. Don't even try to give the
> > impression this is changeable.
> 
> If that's what worries you, add a comment next to the definition,
> perhaps?

That and that the code just looks more like the rest of the block layer
code. Only a few users (UFS, MSDOS, HFS, IDE) use a predefined
SECTOR_{SHIFT,SIZE}.

> It's there so you can easily locate all the places within dm that
> perform these conversions by using a simple search.  Searching for '9'
> wouldn't be as easy.  (I don't know about other people, but I find the
> code easier to read the way it is.)

Hmm, so I guess this is more about dis/like of how the code looks. Maybe we
should define a global SECTOR_{SIZE,SHIFT} into blkdev.h.

Regards,
	Jan

-- 
Jan Blunck <jblunck@suse.de>
