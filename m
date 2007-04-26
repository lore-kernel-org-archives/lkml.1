Return-Path: <linux-kernel-owner+w=401wt.eu-S1751856AbXDZTQi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751856AbXDZTQi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 15:16:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754932AbXDZTQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 15:16:37 -0400
Received: from lotis.site5.com ([70.47.36.45]:51479 "EHLO lotis.site5.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751856AbXDZTQg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 15:16:36 -0400
X-Greylist: delayed 3239 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Apr 2007 15:16:36 EDT
Date: Thu, 26 Apr 2007 13:22:27 -0500 (CDT)
From: Chase Venters <chase.venters@clientec.com>
X-X-Sender: root@turbotaz.ourhouse
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Back to the future.
In-Reply-To: <alpine.LFD.0.98.0704260941310.9964@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0704261321590.2588@turbotaz.ourhouse>
References: <1177567481.5025.211.camel@nigel.suspend2.net> 
 <84144f020704260028q190fc90fs8f9ea703e42e7910@mail.gmail.com>
 <1177573348.5025.224.camel@nigel.suspend2.net>
 <alpine.LFD.0.98.0704260941310.9964@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Antivirus-Scanner: This message has been scanned by ClamAV.
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - lotis.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - clientec.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Apr 2007, Linus Torvalds wrote:

>
> Once you have that snapshot image in user space you can do anything you
> want. And again: you'd hav a fully working system: not any degradation
> *at*all*. If you're in X, then X will continue running etc even after the
> snapshotting, although obviously the snapshotting will have tried to page
> a lot of stuff out in order to make the snapshot smaller, so you'll likely
> be crawling.
>

In fact... If you're just paging out to make a smaller snapshot (ie, not
to free up memory), couldn't you just swap it out (if it's not backed by a
file) then mark it as "half-released"... ie, the snapshot writing code
ignores it knowing that it will be available on disk at resume, but then
when the snapshot is complete it's still available in physical RAM,
preventing user-space from crawling due to the necessity of paging it all
back in?

Thanks,
Chase


