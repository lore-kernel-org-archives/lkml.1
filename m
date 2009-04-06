Return-Path: <linux-kernel-owner+w=401wt.eu-S1757417AbZDFT7J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757417AbZDFT7J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 15:59:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752249AbZDFT6y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 15:58:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43348 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751804AbZDFT6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 15:58:54 -0400
Date: Mon, 6 Apr 2009 12:57:09 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Theodore Tso <tytso@mit.edu>
cc: Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/8][RFC] IO latency/throughput fixes
In-Reply-To: <20090406183157.GD7376@mit.edu>
Message-ID: <alpine.LFD.2.00.0904061255160.4134@localhost.localdomain>
References: <1239022088-29002-1-git-send-email-jens.axboe@oracle.com> <alpine.LFD.2.00.0904060803141.4023@localhost.localdomain> <20090406151054.GD5178@kernel.dk> <alpine.LFD.2.00.0904060840080.3863@localhost.localdomain> <20090406183157.GD7376@mit.edu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 6 Apr 2009, Theodore Tso wrote:
> 
> Cool!  Maybe we can make things even better, but given where we are
> at, this brings up an question: given Jens block latency patches
> (thanks, Jens!), and the patches which add the flush on
> replace-via-rename/replace-via-truncate for ext3 data=writeback,
> should we make ext3 data=writeback the default for 2.6.30?

Yes. I want to go back and see how much this all helps for the 
data=ordered case (if at all), but I think we should at least consider 
trying 'data=writeback' as a default.

Does the 'synchronize on rename / close-after-ftrucate' patches leave any 
other intersting cases open?

			Linus
