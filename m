Return-Path: <linux-kernel-owner+w=401wt.eu-S1756769AbYKCQhn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756769AbYKCQhn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 11:37:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755806AbYKCQhS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 11:37:18 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53587 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754798AbYKCQhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 11:37:16 -0500
Date: Mon, 3 Nov 2008 08:36:45 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Airlie <airlied@gmail.com>
cc: Keith Packard <keithp@keithp.com>, Ingo Molnar <mingo@elte.hu>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Dave Airlie <airlied@linux.ie>,
       Yinghai Lu <yinghai@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: io resources and cached mappings (was: [git pull] drm patches
 for 2.6.27-rc1)
In-Reply-To: <21d7e9970811022300o2576b437kb35a55e2751889f6@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0811030833340.3459@nehalem.linux-foundation.org>
References: <20081022093615.GF12453@elte.hu>  <1224746087-13991-1-git-send-email-keithp@keithp.com>  <20081023080553.GB14714@elte.hu>  <1224776350.6738.14.camel@koto.keithp.com> <21d7e9970811022300o2576b437kb35a55e2751889f6@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 3 Nov 2008, Dave Airlie wrote:
> 
> So I've put these patches into Fedora rawhide kernel to test, and 
> glxgears on my 945G hw went from 85fps to 380fps, clearly we would want 
> these patches upstream sooner rather than later.

I'm inclined to agree. Not that I think 380fps sounds very impressive (I 
get 850+ fps with _software_ rendering, for chissake), but because 85 fps 
is a joke, and clearly without this setup there's not even any point to 
try to do any other optimizations.

And if we're looking at the patches being in Fedora anyway, there really 
is no reason not to merge them. Even if it's out of the merge window.

Ingo?

			Linus
