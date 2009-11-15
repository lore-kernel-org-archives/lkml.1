Return-Path: <linux-kernel-owner+w=401wt.eu-S1751891AbZKOXXL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751891AbZKOXXL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 18:23:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751028AbZKOXXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 18:23:10 -0500
Received: from mga05.intel.com ([192.55.52.89]:25009 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750895AbZKOXXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 18:23:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,747,1249282800"; 
   d="scan'208";a="514122686"
Date: Mon, 16 Nov 2009 00:25:02 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mfd: pcf50633 - fix error handling during probe
Message-ID: <20091115232501.GF8367@sortiz.org>
References: <20091109092447.29634.79364.stgit@localhost.localdomain>
 <20091109092516.29634.32640.stgit@localhost.localdomain>
 <4B008A22.80909@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B008A22.80909@metafoo.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 16, 2009 at 12:09:22AM +0100, Lars-Peter Clausen wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Dmitry Torokhov wrote:
> > The pcf50633 is very naive - it assumes that all driver core
> > operations will succeed and will fail badly if one of them
> > errors out. Implement proper error handling and make sure we
> > release any and all resources that have been allocated prior
> > to failure.
> >
> > Also avoid memory leak when using platform_device_add_data()
> > which clones the supplied data structure for use by the device.
> > The original copy, if allocated dynamically, needs to be freed
> > by the caller; switch to using on-stack variable (the size of
> > the structure in question is quite small) instead.
> >
> > Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
> Hi
> 
> Most of the issues addressed in this patch have already been fixed.
> Please check the for-next branch in the mfd tree.
Oops, thanks for refreshing our memories Lars...

Cheers,
Samuel.

 
> - - Lars
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.9 (GNU/Linux)
> Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org
> 
> iEYEARECAAYFAksAiiIACgkQBX4mSR26RiNJbACfYs4UhLSrlYuNqynJ/Mguw+oj
> FxQAn2xmUh8QZttY4jxKUsdg+6p/pXNT
> =yCtL
> -----END PGP SIGNATURE-----
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
