Return-Path: <linux-kernel-owner+w=401wt.eu-S1754702AbYKCHAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702AbYKCHAp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 02:00:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752123AbYKCHAg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 02:00:36 -0500
Received: from rn-out-0910.google.com ([64.233.170.190]:47633 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751AbYKCHAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 02:00:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=c5lZdMjPRWB/STXhIL/W8CsXJrjRRe1TVtbPCn8Q5K4GsG+lI4tqoz6okVvYf9CdJc
         rrpACpljJsUcQ2bZt0ZRknvkxPgEdu9+VlcyhVSZcCeMRZBwoP3lQpoNxfSC9H1w0QP6
         +O+QST5k3DikDaI7G4//sdMKNVqEY1cEw7CGQ=
Message-ID: <21d7e9970811022300o2576b437kb35a55e2751889f6@mail.gmail.com>
Date: Mon, 3 Nov 2008 17:00:33 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Keith Packard" <keithp@keithp.com>
Subject: Re: io resources and cached mappings (was: [git pull] drm patches for 2.6.27-rc1)
Cc: "Ingo Molnar" <mingo@elte.hu>, "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Dave Airlie" <airlied@linux.ie>, "Yinghai Lu" <yinghai@kernel.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <1224776350.6738.14.camel@koto.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081022093615.GF12453@elte.hu>
	 <1224746087-13991-1-git-send-email-keithp@keithp.com>
	 <20081023080553.GB14714@elte.hu>
	 <1224776350.6738.14.camel@koto.keithp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2008 at 1:39 AM, Keith Packard <keithp@keithp.com> wrote:
> On Thu, 2008-10-23 at 10:05 +0200, Ingo Molnar wrote:
>
>> Any ballpark-figure numbers you can share with us?
>
> For one quake-3 based game we use for performance regression checking,
> 64-bit kernels run about 18 times faster now. That's the difference
> between using a zero-cost dynamic mapping and using ioremap_wc for each
> page.
>
> --
> keith.packard@intel.com
>

So I've put these patches into Fedora rawhide kernel to test, and
glxgears on my
945G hw went from 85fps to 380fps, clearly we would want these patches
upstream sooner
rather than later.

Or we at least need something in the i915 driver to get the speed
under GEM back up.

I'm happy to ship these patches in F10 GA if that makes any
difference, so I'd really like them upstream asap.

Dave.
