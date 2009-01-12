Return-Path: <linux-kernel-owner+w=401wt.eu-S1757278AbZALVcq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757278AbZALVcq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 16:32:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753531AbZALVci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 16:32:38 -0500
Received: from dspnet.fr.eu.org ([213.186.44.138]:3296 "EHLO dspnet.fr.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753291AbZALVch (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 16:32:37 -0500
Date: Mon, 12 Jan 2009 22:32:35 +0100
From: Olivier Galibert <galibert@pobox.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Dave Airlie <airlied@gmail.com>, Jan Dittmer <jdi@l4x.org>,
       Diego Calleja <diegocg@gmail.com>, linux-kernel@vger.kernel.org,
       eric.anholt@iintel.com, airlied@linux.ie
Subject: Re: intel kms "Failed to allocate space for kernel memory manager"
Message-ID: <20090112213235.GA58682@dspnet.fr.eu.org>
Mail-Followup-To: Olivier Galibert <galibert@pobox.com>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	Dave Airlie <airlied@gmail.com>, Jan Dittmer <jdi@l4x.org>,
	Diego Calleja <diegocg@gmail.com>, linux-kernel@vger.kernel.org,
	eric.anholt@iintel.com, airlied@linux.ie
References: <621d098f0901110546p2b99a525k5de54e37fa181197@mail.gmail.com> <21d7e9970901120004t2dd68241x6b9533f489601109@mail.gmail.com> <20090112130343.GA89729@dspnet.fr.eu.org> <200901120953.50167.jbarnes@virtuousgeek.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901120953.50167.jbarnes@virtuousgeek.org>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 09:53:49AM -0800, Jesse Barnes wrote:
> On the contrary, I think we have way too many options and configuration 
> possibilities.  The more we have, the more likely some combination of them 
> will be broken.

You need to be able to fix wrong data coming from the bios or other roms.


> That said, modes are generally pretty easy to handle, so users can provide 
> them through xrandr and xorg.conf; I don't see that changing.

The intel driver ignores modelines if a bios mode is present, at least
for lvds.  Check i830_lvds_mode_fixup.

  OG.
