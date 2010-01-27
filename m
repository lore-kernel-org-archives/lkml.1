Return-Path: <linux-kernel-owner+w=401wt.eu-S1755785Ab0A0RVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755785Ab0A0RVu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 12:21:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755588Ab0A0RVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 12:21:49 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41786 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755409Ab0A0RVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 12:21:49 -0500
Date: Wed, 27 Jan 2010 09:19:50 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Chris Wilson <chris@chris-wilson.co.uk>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, Roman Jarosz <kedgedev@gmail.com>,
       A Rojas <nqn1976list@gmail.com>,
       "A. Boulan" <arnaud.boulan@libertysurf.fr>, michael@reinelt.co.at,
       jcnengel@googlemail.com, rientjes@google.com, earny@net4u.de,
       linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Eric Anholt <eric@anholt.net>,
       stable@kernel.org
Subject: Re: [PATCH] drm/i915: Selectively enable self-reclaim
In-Reply-To: <89k77n$ms73l9@fmsmga001.fm.intel.com>
Message-ID: <alpine.LFD.2.00.1001270917120.24253@localhost.localdomain>
References: <alpine.LFD.2.00.1001270327580.24253@localhost.localdomain> <1264605932-8540-1-git-send-email-chris@chris-wilson.co.uk> <alpine.LFD.2.00.1001270738220.24253@localhost.localdomain> <89k77n$ms73l9@fmsmga001.fm.intel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 27 Jan 2010, Chris Wilson wrote:
> 
> Yes, it survives a short torture test that leaks lots of bo objects from
> X. Obviously this patch depends upon the new interface.

All right. I'll apply my patch, since i'd rather have any half-way complex 
logic for handling mappings in the generic mm code. And then I'll apply 
yours, because now I can look at it without wanting to dig my eyes out.

Thanks,

		Linus
