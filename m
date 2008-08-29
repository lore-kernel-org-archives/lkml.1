Return-Path: <linux-kernel-owner+w=401wt.eu-S1756274AbYH2Ksj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756274AbYH2Ksj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 06:48:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756079AbYH2Ks3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 06:48:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:34300 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752463AbYH2Ks2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 06:48:28 -0400
Message-ID: <48B7D3AE.3050108@kernel.org>
Date: Fri, 29 Aug 2008 12:47:10 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Miklos Szeredi <miklos@szeredi.hu>,
       fuse-devel@lists.sourceforge.net
Subject: Re: [ANNOUNCE] OSS Proxy using CUSE
References: <48B6F711.1040604@kernel.org> <s5htzd4gl3n.wl%tiwai@suse.de>
In-Reply-To: <s5htzd4gl3n.wl%tiwai@suse.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 29 Aug 2008 10:48:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Takashi Iwai wrote:
> Thanks for info.  Just a quick glance, CUSE looks like a good
> abstraction for this kind of things.
> 
> I've been thinking that the tunneling to an OSS-emulation daemon would
> be the best way, too, and I actually made a similar hack (not based on
> FUSE but own kernel module).
> 
> It was presented in SUSE Labs conference a few years ago.  And the
> reaction by audience at that time was what Adrian showed -- why do we
> need such a complexity at all?  Well, as long as we have OSS API and
> its applications, we should keep supporting them in a good form.
> 
> Anyway, my implementation at that time was too hackish and I gave up
> soon.  If it can be implemented in a generic framework like CUSE,
> it's a good chance to merge to the upstream.
> 
> One thing I couldn't find in your code is the mmap support.
> The mmap support is crucial for some apps, typically used for games.
> Am I missing something?

mmap is essential for some apps?  Aiee... I was hoping to skip that one
after reading strong discouragement against it in the OSS programming
manual from 4front.

Adding it shouldn't be too difficult.  I'll give it a shot after other
stuff settles down.

Thanks.

-- 
tejun
