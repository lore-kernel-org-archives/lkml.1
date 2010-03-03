Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894Ab0CCWHj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 17:07:39 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43300 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754430Ab0CCWHd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 17:07:33 -0500
Date: Wed, 3 Mar 2010 14:04:50 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 19/62] Driver-Core: devtmpfs - remove EXPERIMENTAL and
 enable it by default
Message-ID: <20100303220450.GA10391@suse.de>
References: <20100302230933.GA32287@kroah.com>
 <1267572541-410-19-git-send-email-gregkh@suse.de>
 <m1635eow8a.fsf@fess.ebiederm.org>
 <alpine.LFD.2.00.1003030839550.3627@localhost.localdomain>
 <20100303212236.GA9732@suse.de>
 <alpine.LFD.2.00.1003031340570.3599@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1003031340570.3599@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 03, 2010 at 01:48:08PM -0800, Linus Torvalds wrote:
> 
> Anyway, I don't know whether you picked a good spot to do your series or 
> not, but it _looked_ like a pretty random spot. It might be perfectly 
> good. But just in general, since you always generate your trees from a 
> quilt series anyway, I suspect we migth be better off (at least for the 
> initial merge window series) to base them on the closest thing we have to 
> a "known good" base, namely the previous release. Rather than some "maybe 
> fine" point in the middle of the merge window.

I originally did the create from the 2.6.33 release, and then did a
merge to test that it would be easy for you, but there were a number of
conflicts due to other trees touching some driver core stuff (that I
knew was going to happen.)  So I did take a merge point after that had
happened, and did test it out here on my machines.

But hey, if you want to have to handle merge conflicts, I'll gladly base
them on known-common points in the future :)

In the future I'll try to pick better merge points.

thanks,

greg k-h
