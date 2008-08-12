Return-Path: <linux-kernel-owner+w=401wt.eu-S1754374AbYHLNBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374AbYHLNBV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 09:01:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754013AbYHLNAw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 09:00:52 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:57448 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754077AbYHLNAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 09:00:51 -0400
Date: Tue, 12 Aug 2008 15:59:06 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Dave Airlie <airlied@linux.ie>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH -next] drm: sis depends on FB_SIS
Message-ID: <20080812125906.GC13910@cs181140183.pp.htv.fi>
References: <20080807083228.0fc40405.randy.dunlap@oracle.com> <alpine.DEB.0.82.0808080008050.13875@skynet.skynet.ie> <20080807175552.67d5385d.randy.dunlap@oracle.com> <alpine.DEB.0.82.0808080309270.13875@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.DEB.0.82.0808080309270.13875@skynet.skynet.ie>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2008 at 03:11:03AM +0100, Dave Airlie wrote:
> 
> > > If someone asks for sisfb then sis drm uses code from it, if they don't 
> > > ask for it it doesn't. So I want sisfb to be built in if its selected and 
> > > sis drm is built-in.
> > 
> > config DRM_SIS
> > 	select FB_SIS
> 
> Maybe the other way around, I don't want DRM_SIS influencing whether 
> FB_SIS is on or off, if the user wants sisfb on, then when they select it, 
> DRM_SIS should be built in the same way. But if sisfb isn't selected by 
> the user, then selecting DRM_SIS shouldn't enable it.

If FB_SIS=m, should DRM_SIS=y be allowed or should in this case DRM_SIS 
be restricted to n/m?

> Dave.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

