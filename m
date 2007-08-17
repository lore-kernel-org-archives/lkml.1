Return-Path: <linux-kernel-owner+w=401wt.eu-S1758486AbXHQDz4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758486AbXHQDz4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 23:55:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757351AbXHQDzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 23:55:44 -0400
Received: from waste.org ([66.93.16.53]:40064 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753992AbXHQDzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 23:55:43 -0400
Date: Thu, 16 Aug 2007 22:56:41 -0500
From: Matt Mackall <mpm@selenic.com>
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Andrew Morton <akpm@osdl.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
       David Rientjes <rientjes@google.com>,
       John Berthels <jjberthels@gmail.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] maps: /proc/<pid>/pmaps interface - memory maps in granularity of pages
Message-ID: <20070817035641.GK30556@waste.org>
References: <20070816220516.782145952@mail.ustc.edu.cn> <20070816220849.472883642@mail.ustc.edu.cn> <20070817023846.GJ30556@waste.org> <20070817034437.GC5521@mail.ustc.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070817034437.GC5521@mail.ustc.edu.cn>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2007 at 11:44:37AM +0800, Fengguang Wu wrote:
> > I'm so-so on this. 
> 
> Not that way! It's a good thing that people have different experiences
> and hence viewpoints. Maybe the concept of PFN sharing are
> straightforward to you, while I have been playing with seq_file a lot.
> 
> > On the downside:
> > 
> > - requires lots of parsing
> > - isn't random-access
> > - probably significantly slower than pagemap
> 
> That could be true.  Maybe some user with huge datasets will give us
> some idea about the performance. I don't know, maybe it's application
> dependent.
> 
> Anyway I don't think it's fair to merge a binary interface without the
> challenge from a textual one ;)

Yes, that's why I didn't say I hated it.

-- 
Mathematics is the supreme nostalgia of our time.
