Return-Path: <linux-kernel-owner+w=401wt.eu-S1756694AbZLUMDP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756694AbZLUMDP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 07:03:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753140AbZLUMDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 07:03:13 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:64525 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753032AbZLUMDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 07:03:12 -0500
Date: Mon, 21 Dec 2009 04:03:06 -0800 (PST)
From: Christian Kujau <lists@nerdbynature.de>
To: Andrey Rahmatullin <wrar@altlinux.org>
cc: LKML <linux-kernel@vger.kernel.org>, Roger Luethi <rl@hellgate.ch>,
       netdev@vger.kernel.org
Subject: Re: via_rhine kernel crashes in 2.6.32
In-Reply-To: <20091220200343.GA5427@wrars-comp.wrarsdomain>
Message-ID: <alpine.DEB.2.01.0912210352200.3483@bogon.housecafe.de>
References: <20091219111206.GA5307@wrars-comp.wrarsdomain> <20091220200343.GA5427@wrars-comp.wrarsdomain>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX1/8r5b30UFt61xfAROiDegeZ3v5yjjj8AR1+Wy
 YhQskUg/YekMPHWDekSkKMv7iiBmHLNprjBx5UOcccYX0OX2//
 M25Rz7/0K4DGoVMI7tBFA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[netdev Cc'ed]

On Mon, 21 Dec 2009 at 01:03, Andrey Rahmatullin wrote:
> Here are the proper screenshots from 2.6.33-rc1:
> http://wrar.name/temp/P1010724.JPG
> http://wrar.name/temp/P1010725.JPG

Wow, I had to rotate my laptop here. In you first posting [0] you said you 
"upgraded to .32" but had crashes in .30 too. What was the last working 
kernel?

In the .jpgs one can see something along the lines of 
schedule_timeout, napi_disable, rhine_tx_timeout - the only patch I could 
find touching these things [1] altogether is rather old, from 2.6.24. Is 
2.6.29 working for you? 

Christian.

[0] http://lkml.org/lkml/2009/12/19/36
[1] http://lists.openwall.net/netdev/2007/08/28/13
-- 
BOFH excuse #19:

floating point processor overflow
