Return-Path: <linux-kernel-owner+w=401wt.eu-S1757162AbXD0Uzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757162AbXD0Uzw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 16:55:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757242AbXD0Uzw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 16:55:52 -0400
Received: from nz-out-0506.google.com ([64.233.162.224]:22652 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757154AbXD0Uy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 16:54:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=M0lNcCwLv6aiv/PgeuvNWpKO0pFH6qWnak/XaNMPJ7Lf1pBvCkcDkMTFDe6yjmXU9b4JT8vHC/hZaRSNUSklduZ/CpeLRVlX4w77mM8YAbBKzcXnYjx4skgzgfj3hDQ0lWrfcIktLr0Ym+u5WaBVWfK1gG7WW5ZI8OeD0N/FvIs=
Message-ID: <46326309.3050104@gmail.com>
Date: Sat, 28 Apr 2007 02:24:33 +0530
From: Manoj Joseph <manoj.joseph@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andreas Dilger <adilger@clusterfs.com>,
       Marat Buharov <marat.buharov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, LKML <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
       Alex Tomas <alex@clusterfs.com>
Subject: Re: [ext3][kernels >= 2.6.20.7 at least] KDE going comatose when
 FS is under heavy write load (massive starvation)
References: <1177660767.6567.41.camel@Homer.simpson.net> <20070427013350.d0d7ac38.akpm@linux-foundation.org> <698310e10704270459t7663d39dp977cf055b8db9d2a@mail.gmail.com> <alpine.LFD.0.98.0704270819500.9964@woody.linux-foundation.org> <20070427193130.GD5967@schatzie.adilger.int> <alpine.LFD.0.98.0704271246550.9964@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0704271246550.9964@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Fri, 27 Apr 2007, Andreas Dilger wrote:
>> It's true that this is a "feature" of ext3 with data=ordered (the default),
>> but I suspect the same thing is now true in reiserfs too.
> 
> Oh, well.. Journalling sucks.

Go back to ext2? ;)

> I was actually _really_ hoping that somebody would come along and tell 
> everybody that this whole journal-logging is stupid, and that it's just 
> better to not ever re-write blocks on disk, but instead write to new 
> blocks with version numbers (and not re-use old blocks until new versions 
> are stable on disk).

Ah, "copy on write"! ZFS (Sun) and WAFL (NetApp) does this. Don't know 
about WAFL, but ZFS does logging too.

-Manoj

-- 
Manoj Joseph
http://kerneljunkie.blogspot.com/

