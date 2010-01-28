Return-Path: <linux-kernel-owner+w=401wt.eu-S932221Ab0A1GjK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932221Ab0A1GjK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 01:39:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752029Ab0A1GjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 01:39:09 -0500
Received: from 1wt.eu ([62.212.114.60]:55084 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752026Ab0A1GjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 01:39:08 -0500
Date: Thu, 28 Jan 2010 07:37:39 +0100
From: Willy Tarreau <w@1wt.eu>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Roman Jarosz <kedgedev@gmail.com>, A Rojas <nqn1976list@gmail.com>,
       "A. Boulan" <arnaud.boulan@libertysurf.fr>, michael@reinelt.co.at,
       jcnengel@googlemail.com, rientjes@google.com, earny@net4u.de,
       linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Eric Anholt <eric@anholt.net>,
       stable@kernel.org
Subject: Re: [PATCH] drm/i915: Selectively enable self-reclaim
Message-ID: <20100128063739.GB7248@1wt.eu>
References: <alpine.LFD.2.00.1001270327580.24253@localhost.localdomain> <1264605932-8540-1-git-send-email-chris@chris-wilson.co.uk> <alpine.LFD.2.00.1001270738220.24253@localhost.localdomain> <89k77n$ms73l9@fmsmga001.fm.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <89k77n$ms73l9@fmsmga001.fm.intel.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 27, 2010 at 05:14:41PM +0000, Chris Wilson wrote:
> On Wed, 27 Jan 2010 08:09:55 -0800 (PST), Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > On Wed, 27 Jan 2010, Chris Wilson wrote:
> > > 
> > > v2: Pass gfp into page mapping.
> > 
> > Ahh, you did need the whole complexity of ->readpage?
> > 
> > Ok, in that case, can you test if this works for you?
> 
> Yes, it survives a short torture test that leaks lots of bo objects from
> X. Obviously this patch depends upon the new interface.

So does this needs that previous patch is still valid for 2.6.32-stable ?
If so, you'll probably have to point it to Greg directly so that he has
no trouble backporting the new one.

Willy

