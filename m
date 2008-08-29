Return-Path: <linux-kernel-owner+w=401wt.eu-S1752069AbYH2Bes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069AbYH2Bes (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 21:34:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750836AbYH2Bek
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 21:34:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:40507 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750833AbYH2Bej (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 21:34:39 -0400
Message-ID: <48B751DA.5090906@kernel.org>
Date: Fri, 29 Aug 2008 03:33:14 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Miklos Szeredi <miklos@szeredi.hu>,
       Takashi Iwai <tiwai@suse.de>, fuse-devel@lists.sourceforge.net
Subject: Re: [ANNOUNCE] OSS Proxy using CUSE
References: <48B6F711.1040604@kernel.org> <20080828200120.GA16462@cs181140183.pp.htv.fi>
In-Reply-To: <20080828200120.GA16462@cs181140183.pp.htv.fi>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 29 Aug 2008 01:34:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> Sorry for being destructive, but 6 years after ALSA went into the
> kernel we are slightly approaching the point where all applications 
> support ALSA.

Yeah, I have to agree it's a bit too late but the exclusion between OSS
and more modern sound systems (be it ALSA or PA) still bugged me quite a
bit.  There always seems this one off app that wasn't quite there - be
it mpg123 for whatever reason I still enjoy to use from time to time,
vmware which is a genuine pain in the ass to get working with LD_PRELOAD
tricks (hopefully 6.5 will finally use ALSA but wait we're all going PA
now...) or scorch-3D (and many other games) where aoss delivers horrible
sound after playing for a while.

> The application you list on your webpage is UML host sound support,
> and I'm wondering why you don't fix that instead of working on a
> better OSS emulation?

Other than OSS emulation, CUSE seemed like an idea which might be able
to stand on its own legs, say, for legacy or proprietary device
emulation or just putting what used to be considered kernel-worthy to
userland.

Anyways, the thing is that unlike what was originally expected, dropping
an major programming API doesn't really work too well even after six
years of trying.  Maybe because OSS is still kicking on other unices.

We now have in-kernel OSS emulation which can't mux with other streams,
aoss with its own supported and broken list and can also be routed
through PA by configuring ALSA right and then padsp with its own
supported and broken list and nothing works good enough.  So, if we have
one thing which just works, we can in time put all those to rest.

Thanks.

-- 
tejun
