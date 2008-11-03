Return-Path: <linux-kernel-owner+w=401wt.eu-S1756223AbYKCPiF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223AbYKCPiF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 10:38:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754912AbYKCPhx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 10:37:53 -0500
Received: from hera.kernel.org ([140.211.167.34]:36481 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754402AbYKCPhx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 10:37:53 -0500
Message-ID: <490F1AC6.8000109@kernel.org>
Date: Tue, 04 Nov 2008 00:37:42 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: petkovbb@gmail.com, Tejun Heo <tj@kernel.org>, axboe@kernel.dk,
       bzolnier@gmail.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] ide-floppy partitions
References: <20081029071319.GA9205@gollum.tnic> <20081101201419.GA29462@gollum.tnic>
In-Reply-To: <20081101201419.GA29462@gollum.tnic>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 03 Nov 2008 15:37:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov wrote:
> can you guys please ACK/NACK this so that we can have an agreed upon solution
> and so that I can stop applying it ontop of current git before testing any
> further.

Ah... right.  I missed removable devices.  I think it would be better to
just expand the table rather than recursing into __blkdev_get() again.
I'll try to come up with cleaner solution.  Also, I don't think the
discontinuous partition would be a problem.  ptbl is expanded to the
highest numbered partition not the number of partitions.  I'll test that
too.  Thanks.

-- 
tejun
