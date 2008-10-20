Return-Path: <linux-kernel-owner+w=401wt.eu-S1754182AbYJTUE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182AbYJTUE3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 16:04:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753069AbYJTUEV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 16:04:21 -0400
Received: from outbound-mail-15.bluehost.com ([69.89.18.115]:32828 "HELO
	outbound-mail-15.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752287AbYJTUEU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 16:04:20 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=egUiSAmaXdQXCyn6jPiLa9S0SqMoLq4lwclTT1FOkxaUE4I3LegO1jctoehXw+IhxA9k5gt36fvf/6aBXiWW18dZDyOZ6OCmcCDQh2HbejKvAs5I9tzp8fgoU8nobm1/;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Eric Anholt <eric@anholt.net>
Subject: Re: [git pull] drm patches for 2.6.27-rc1
Date: Mon, 20 Oct 2008 13:04:09 -0700
User-Agent: KMail/1.10.1 (Linux/2.6.26.5-45.fc9.x86_64; KDE/4.1.2; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Dave Airlie <airlied@linux.ie>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
References: <alpine.DEB.0.82.0810172227490.14817@skynet.skynet.ie> <alpine.LFD.2.00.0810171510170.3438@nehalem.linux-foundation.org> <1224295858.4378.8.camel@vonnegut.anholt.net>
In-Reply-To: <1224295858.4378.8.camel@vonnegut.anholt.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200810201304.09727.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, October 17, 2008 7:10 pm Eric Anholt wrote:
> On Fri, 2008-10-17 at 15:43 -0700, Linus Torvalds wrote:
> > On Fri, 17 Oct 2008, Dave Airlie wrote:
> > So what's the excuse _this_ time for adding all these stupid warnings to
> > my build log? Did nobody test this?
> >
> >   drivers/gpu/drm/drm_proc.c: In function ‘drm_gem_one_name_info’:
> >   drivers/gpu/drm/drm_proc.c:525: warning: format ‘%d’ expects type
> > ‘int’, but argument 3 has type ‘size_t’ drivers/gpu/drm/drm_proc.c:533:
> > warning: format ‘%9d’ expects type ‘int’, but argument 4 has type
> > ‘size_t’ drivers/gpu/drm/i915/i915_gem.c: In function
> > ‘i915_gem_gtt_pwrite’: drivers/gpu/drm/i915/i915_gem.c:184: warning:
> > unused variable ‘vaddr_atomic’
>
> Yeah, none of us are on x86-64, so we missed those warnings in testing.

Actually, I'm on x86_64 pretty much exclusively and saw these warnings last 
week.  But I didn't send a fix (yet); sorry.

That said, this code was far from untested, even though it did contain a few 
compile warnings, so I think Linus's complaint about UNTESTED CRAP was at 
least half wrong.

-- 
Jesse Barnes, Intel Open Source Technology Center

