Return-Path: <linux-kernel-owner+w=401wt.eu-S1754333AbZFVWvn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333AbZFVWvn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 18:51:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752631AbZFVWvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 18:51:35 -0400
Received: from gir.skynet.ie ([193.1.99.77]:40439 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752784AbZFVWvf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 18:51:35 -0400
Date: Mon, 22 Jun 2009 23:51:35 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: =?UTF-8?Q?Ozan_=C3=87a=C4=9Flayan?= <ozan@pardus.org.tr>
cc: linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Subject: Re: [git pull] drm v2.6.31 merge (part 1)
In-Reply-To: <4A3FF03A.4050401@pardus.org.tr>
Message-ID: <alpine.DEB.2.00.0906222350570.20307@skynet.skynet.ie>
References: <alpine.DEB.2.00.0906120720410.11737@skynet.skynet.ie> <4A3FF03A.4050401@pardus.org.tr>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Date:   Thu Jun 11 16:16:10 2009 +1000
> >
> >     radeon: remove _DRM_DRIVER from the preadded sarea map
> >     
> >     This shouldn't be there and is what broke r600 late in the 2.6.30
> >     release cycle with Ben's patch.
> >     
> >     Signed-off-by: Dave Airlie <airlied@redhat.com>
> >   
> 
> Hi,
> 
> I wonder what kind of *breaking* should be expected without this commit
> on r600'? I'm having serious lockups on X (RS690) and I don't have this
> commit applied, I'll give it a try tomorrow but I'm really curious if it
> may be related to this fix or not.
> 

You don't have an r600, an rs690 isn't an r600 at all.

Can you bisect to where the lockups start or have you always had lockups?

Dave.
