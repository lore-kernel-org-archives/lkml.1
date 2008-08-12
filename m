Return-Path: <linux-kernel-owner+w=401wt.eu-S1752671AbYHLVhQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671AbYHLVhQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 17:37:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751664AbYHLVhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 17:37:04 -0400
Received: from gir.skynet.ie ([193.1.99.77]:44291 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751509AbYHLVhD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 17:37:03 -0400
Date: Tue, 12 Aug 2008 22:37:00 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: Adrian Bunk <bunk@kernel.org>
cc: Randy Dunlap <randy.dunlap@oracle.com>,
       lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH -next] drm: sis depends on FB_SIS
In-Reply-To: <20080812125906.GC13910@cs181140183.pp.htv.fi>
Message-ID: <alpine.DEB.0.82.0808122236130.13090@skynet.skynet.ie>
References: <20080807083228.0fc40405.randy.dunlap@oracle.com>
 <alpine.DEB.0.82.0808080008050.13875@skynet.skynet.ie>
 <20080807175552.67d5385d.randy.dunlap@oracle.com>
 <alpine.DEB.0.82.0808080309270.13875@skynet.skynet.ie>
 <20080812125906.GC13910@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > 
> > Maybe the other way around, I don't want DRM_SIS influencing whether 
> > FB_SIS is on or off, if the user wants sisfb on, then when they select it, 
> > DRM_SIS should be built in the same way. But if sisfb isn't selected by 
> > the user, then selecting DRM_SIS shouldn't enable it.
> 
> If FB_SIS=m, should DRM_SIS=y be allowed or should in this case DRM_SIS 
> be restricted to n/m?

Probably not. if FB_SIS is selected at all, DRM_SIS should match it, if 
FB_SIS isn't selected, DRM_SIS should not select it.

Dave.
