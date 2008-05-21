Return-Path: <linux-kernel-owner+w=401wt.eu-S936917AbYEUVe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936917AbYEUVe4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 17:34:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755154AbYEUVen
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 17:34:43 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:2886 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753317AbYEUVel (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 17:34:41 -0400
Date: Wed, 21 May 2008 17:03:52 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Marcel Holtmann <marcel@holtmann.org>, netdev <netdev@vger.kernel.org>,
       Jean Tourrilhes <jt@hpl.hp.com>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] make wext wireless bits optional and deprecate them
Message-ID: <20080521210352.GA11827@tuxdriver.com>
References: <1211026337.3827.25.camel@johannes.berg> <CD993362-B1DE-4E4D-8A5B-E9E2AD7DA04C@holtmann.org> <1211303731.6252.105.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1211303731.6252.105.camel@johannes.berg>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2008 at 07:15:31PM +0200, Johannes Berg wrote:
> On Sat, 2008-05-17 at 15:45 +0200, Marcel Holtmann wrote:
> > Hi Johannes,
> > 
> > > The /sys/class/net/*/wireless/ direcory is, as far as I know, not
> > > used by anyone. Additionally, the same data is available via wext
> > > ioctls. Hence the sysfs files are pretty much useless. This patch
> > > makes them optional and schedules them for removal.
> > 
> > it is used by HAL to classify WiFi network cards as net.80211 instead  
> > of net.80203 and so we do have an actual user. However HAL only tests  
> > for the existence of the directory wireless/.
> > 
> > Please fix HAL first before submitting such a patch.
> 
> I have filed a patch to fix HAL to use the canonical SIOCGIWNAME at
> https://bugs.freedesktop.org/show_bug.cgi?id=16037. Any further
> objections to this patch?

I think this is going to fall under the "userland ABI" category.
We can make it a configurable option, but I don't think we are free
to remove it completely since there is at least existing versions of
HAL that use it.

John
-- 
John W. Linville
linville@tuxdriver.com
