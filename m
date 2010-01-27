Return-Path: <linux-kernel-owner+w=401wt.eu-S1754125Ab0A0K5F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125Ab0A0K5F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 05:57:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752713Ab0A0K5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 05:57:04 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42483 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751845Ab0A0K5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 05:57:01 -0500
Date: Wed, 27 Jan 2010 02:55:42 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Chris Wilson <chris@chris-wilson.co.uk>,
       Roman Jarosz <kedgedev@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
       A Rojas <nqn1976list@gmail.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       "A. Boulan" <arnaud.boulan@libertysurf.fr>, michael@reinelt.co.at,
       jcnengel@googlemail.com, rientjes@google.com, earny@net4u.de,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Eric Anholt <eric@anholt.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: OOM-Killer kills too much with 2.6.32.2
In-Reply-To: <84144f021001270156x7613c8b1ha0084b0abf604775@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1001270252290.24253@localhost.localdomain>
References: <2f11576a1001260503o5f987512n3c39ae1c3caa43f3@mail.gmail.com>  <89khjo$egh4fr@orsmga002.jf.intel.com>  <20100127091903.6AD5.A69D9226@jp.fujitsu.com> <84144f021001270156x7613c8b1ha0084b0abf604775@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 27 Jan 2010, Pekka Enberg wrote:
> 
> Yes, we're very late in 2.6.33 cycle. Chris/Jesse, please apply
> Motohiro-san's patch or revert the commit.

I assume you're talking about reverting commit 07f73f691 ("drm/i915: 
Improve behaviour under memory pressure").

Motohiro-san's patch didn't have a sign-off or a commit message. I guess I 
could cobble some commit message together from the thread, but it would be 
good if somebody involved with the code were to do so. Please?

		Linus
