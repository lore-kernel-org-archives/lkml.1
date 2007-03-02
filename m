Return-Path: <linux-kernel-owner+w=401wt.eu-S2992597AbXCBQiq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992597AbXCBQiq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 11:38:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992598AbXCBQiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 11:38:46 -0500
Received: from ns2.suse.de ([195.135.220.15]:35277 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992597AbXCBQip (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 11:38:45 -0500
Message-ID: <45E85316.50101@suse.de>
Date: Fri, 02 Mar 2007 17:38:46 +0100
From: Gerd Hoffmann <kraxel@suse.de>
Organization: =?ISO-8859-1?Q?SUSE_LINUX_Products_GmbH=2C_GF=3A_?=
 =?ISO-8859-1?Q?Markus_Rex=2C_HRB_16746_=28AG_N=FCrnberg=29?=
User-Agent: Thunderbird 1.5.0.9 (X11/20060911)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [patch] Fixes and cleanups for earlyprintk aka boot console.
References: <45DADD15.7070809@suse.de> <20070301234645.09da8484.akpm@linux-foundation.org> <45E7F3D0.7090105@suse.de> <45E84B9A.1000003@goop.org>
In-Reply-To: <45E84B9A.1000003@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Gerd Hoffmann wrote:
>> Hmm, I think this is just a chunk being lost due to the clash with the
>> older version of the patch submitted as part of the xen series.
> 
> But I thought the old version I had posted was well and truly dropped. 
> Isn't this problematic patch the one you posted?

I think what happened is (the patch attached to the "removed from -mm"
mail looks like this):

  - patch-v2 merged into -mm
  - patch-v1 merged into -mm as part of xen series
  - merge conflict, the bits which are in patch-v1 got removed
    from patch-v2 to solve that, both patches in -mm
  - patch-v1 got removed with other xen bits due to the conflict
    with zachs patches.
  - mm kernel has an incomplete patch-v2 now => boom.

So it isn't a problem with the original patch, it just got corrupted
during conflict resolving.

cheers,
  Gerd

-- 
Gerd Hoffmann <kraxel@suse.de>
