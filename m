Return-Path: <linux-kernel-owner+w=401wt.eu-S933236AbZIDHFf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933236AbZIDHFf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 03:05:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933201AbZIDHFb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 03:05:31 -0400
Received: from cantor.suse.de ([195.135.220.2]:56770 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756671AbZIDHFF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 03:05:05 -0400
Date: Fri, 4 Sep 2009 09:05:06 +0200
From: Nick Piggin <npiggin@suse.de>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch 00/33] my current vfs scalability patch queue
Message-ID: <20090904070506.GA1875@wotan.suse.de>
References: <20090904065142.114706411@nick.local0.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090904065142.114706411@nick.local0.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 04, 2009 at 04:51:41PM +1000, npiggin@suse.de wrote:
> But it is now getting to the point where I will need to get some agreement with
> the approach.

BTW, yes I'm aware numbers and results are needed. I have some things,
but I don't have that big systems to test with, or really interesting
workoads.

I know google is running into lock contention which is why they proposed
the batched iput dput patches. Peter Chubb hit inode lock contention
with reaim (don't konw if that is considered realistic). And SGI have
had various lock contention problems with NFS fileservers.

So aside from reviews and suggestions, what would be most helpful to me
would be people willing to test out their problematic workloads with
me. It's the only way I can try to get them fixed.

Thanks,
Nick
