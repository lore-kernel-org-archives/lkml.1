Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083Ab0BOFgO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 00:36:14 -0500
Received: from gir.skynet.ie ([193.1.99.77]:57398 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752424Ab0BOFgN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 00:36:13 -0500
Date: Mon, 15 Feb 2010 05:35:59 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Subject: Re: [git pull] drm fixes
In-Reply-To: <alpine.DEB.2.00.1002150508210.25675@skynet.skynet.ie>
Message-ID: <alpine.DEB.2.00.1002150534250.25675@skynet.skynet.ie>
References: <alpine.DEB.2.00.1002150508210.25675@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Two ttm regression fixes from Thomas, and one alpha unaligned issue in the
> atom parser for radeon KMS.

And as usual I read my TODO list after I send the push req out.

One more commit on top of this tree now

just a fix to the DP retry logic:
e803e8b2628f3e9a42f45c5b7bb1f9821b08352c drm/radeon/kms: make sure retry count increases.

In testing I've never seen it go past 1 retry anyways but better
safe than sorry.
    
Reported by Droste on irc.
   
Signed-off-by: Dave Airlie <airlied@redhat.com>

Dave.
