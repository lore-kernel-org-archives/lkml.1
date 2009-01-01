Return-Path: <linux-kernel-owner+w=401wt.eu-S1755979AbZAAEES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979AbZAAEES (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 23:04:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753829AbZAAEED
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 23:04:03 -0500
Received: from one.firstfloor.org ([213.235.205.2]:60026 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753620AbZAAEED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 23:04:03 -0500
Date: Thu, 1 Jan 2009 05:17:27 +0100
From: Andi Kleen <andi@firstfloor.org>
To: david@lang.hm
Cc: Andi Kleen <andi@firstfloor.org>, Cyrill Gorcunov <gorcunov@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: early exception error
Message-ID: <20090101041727.GW496@one.firstfloor.org>
References: <alpine.DEB.1.10.0812301416550.16847@asgard.lang.hm> <87k59hur5f.fsf@basil.nowhere.org> <alpine.DEB.1.10.0812301737320.16936@asgard.lang.hm> <20081231093803.GA20882@localhost> <alpine.DEB.1.10.0812311110320.18334@asgard.lang.hm> <20081231183039.GE20882@localhost> <20081231195005.GT496@one.firstfloor.org> <alpine.DEB.1.10.0812311257060.18334@asgard.lang.hm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0812311257060.18334@asgard.lang.hm>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 31, 2008 at 12:59:08PM -0800, david@lang.hm wrote:
> On Wed, 31 Dec 2008, Andi Kleen wrote:
> 
> >>on the picture you sent me i noticed the message
> >>"Your memory is not aligned you need to rebuild your
> >>kernel with bigger NODEMAP SIZE shift=20" and then
> >>srat code complains about "No NUMA code hash function found"
> >>which looks a bit scary. Btw, could you post this picture
> >>on some public resource so NUMA people could check it?
> >
> >This case used to be handled cleanly (NUMA disabled), but perhaps
> >that has regressed. But still it sounds like something is going wrong,
> >unless his machine really has a very weird memory map.
> 
> it shouldn't, it was one of the high-volume servers 4-5 years ago and only 
> has 4G of ram in it

>From looking at the screenshot Cyrill sent you seem to have a funny
SRAT with overlapping areas that is rejected in the end. I suspect the 
fallback code doesn't handle this properly.

Does it work when you boot with numa=noacpi ? 

-Andi

