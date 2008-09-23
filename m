Return-Path: <linux-kernel-owner+w=401wt.eu-S1754886AbYIWVUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886AbYIWVUk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 17:20:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753172AbYIWVUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 17:20:30 -0400
Received: from tundra.namei.org ([65.99.196.166]:58584 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752848AbYIWVU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 17:20:29 -0400
Date: Wed, 24 Sep 2008 07:20:01 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
cc: Stephen Smalley <sds@tycho.nsa.gov>, david@lang.hm,
       Kentaro Takeda <takedakn@nttdata.co.jp>,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Toshiharu Harada <haradats@nttdata.co.jp>
Subject: Re: [PATCH] Introduce new LSM hooks where vfsmount is available.
In-Reply-To: <20080923152053.GA6622@x200.localdomain>
Message-ID: <alpine.LRH.1.10.0809240715340.31367@tundra.namei.org>
References: <48C65E9D.3070106@nttdata.co.jp> <5fb14edc0809090902m32431bf6yf518a457e410764d@mail.gmail.com> <20080910134540.45ec1272.akpm@linux-foundation.org> <48C877DE.4040402@nttdata.co.jp> <48D06865.8070602@nttdata.co.jp> <alpine.LRH.1.10.0809231604040.25628@tundra.namei.org>
 <alpine.DEB.1.10.0809222310450.25430@asgard.lang.hm> <1222182167.28396.11.camel@moss-spartans.epoch.ncsc.mil> <20080923152053.GA6622@x200.localdomain>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Sep 2008, Alexey Dobriyan wrote:

> > > > I don't see any technical errors in this patch.
> > > >
> > > > If it is going to be merged, please make a new config option for
> > > > path-based hooks (similar to that for the network hooks), so they can be
> > > > compiled out.
> 
> Another pointless config option.

Why is it pointless?  If distros don't want to use these hooks, they 
shouldn't have to have them enabled.

> 
> It's actually pretty surprising that SECURITY_NETWORK is
> a) user-visible and b) is not SECURITY && NET.
> 
> Same for SECURITY_NETWORK_XFRM.

IIRC, this option was a perquisite for merge.  Networking hooks have a 
relatively high overhead and not everyone wants to use them, even if they 
have networking enabled.


- James
-- 
James Morris
<jmorris@namei.org>
