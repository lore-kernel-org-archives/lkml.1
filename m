Return-Path: <linux-kernel-owner+w=401wt.eu-S1758219AbZBMMVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758219AbZBMMVR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 07:21:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750855AbZBMMVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 07:21:06 -0500
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:37441 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750828AbZBMMVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 07:21:04 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArIDACPylEl5LClxgWdsb2JhbACUTAEBFiK9eYQYBg
X-IronPort-AV: E=Sophos;i="4.38,202,1233495000"; 
   d="scan'208";a="289997061"
Date: Fri, 13 Feb 2009 23:20:51 +1100
From: Dave Chinner <david@fromorbit.com>
To: Eric Sandeen <sandeen@redhat.com>
Cc: Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>,
       Jan Kara <jack@suse.cz>, Theodore Tso <tytso@MIT.EDU>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@suse.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, fernando@kic.ac.jp,
       Ric Wheeler <rwheeler@redhat.com>
Subject: Re: vfs: Add MS_FLUSHONFSYNC mount flag
Message-ID: <20090213122051.GX8830@disturbed>
Mail-Followup-To: Eric Sandeen <sandeen@redhat.com>,
	Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao <fernando@oss.ntt.co.jp>,
	Jan Kara <jack@suse.cz>, Theodore Tso <tytso@MIT.EDU>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@suse.cz>,
	kernel list <linux-kernel@vger.kernel.org>,
	Jens Axboe <jens.axboe@oracle.com>, fernando@kic.ac.jp,
	Ric Wheeler <rwheeler@redhat.com>
References: <1232185639.4831.18.camel@sebastian.kern.oss.ntt.co.jp> <1232186449.4831.29.camel@sebastian.kern.oss.ntt.co.jp> <20090119120349.GA10193@duck.suse.cz> <1233135913.5399.57.camel@sebastian.kern.oss.ntt.co.jp> <20090128095518.GA16554@duck.suse.cz> <1234434811.15270.7.camel@sebastian.kern.oss.ntt.co.jp> <1234434970.15433.4.camel@sebastian.kern.oss.ntt.co.jp> <499458C1.90105@redhat.com> <1234487679.3795.15.camel@sebastian.kern.oss.ntt.co.jp> <49951121.80807@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49951121.80807@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 13, 2009 at 12:20:17AM -0600, Eric Sandeen wrote:
> I'm just a little leery of the "dangerous" mount option proliferation, I
> guess.

You're not the only one, Eric. It's bad enough having to explain to
users what barriers do once they have lost data after a power loss,
let alone confusing them further by adding more mount options they
will get wrong by accident....

Quite frankly, the VFS should do stuff that is slow and safe
and filesystems can choose to ignore the VFS (via filesystem
specific mount options) if they want to be fast and potentially
unsafe.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
