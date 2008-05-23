Return-Path: <linux-kernel-owner+w=401wt.eu-S933514AbYEWGqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933514AbYEWGqu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 02:46:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755611AbYEWGqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 02:46:43 -0400
Received: from brick.kernel.dk ([87.55.233.238]:28970 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754875AbYEWGqm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 02:46:42 -0400
Date: Fri, 23 May 2008 08:46:40 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: reorder cfq_queue to save space on 64bit builds
Message-ID: <20080523064640.GQ7712@kernel.dk>
References: <1211468567.3024.6.camel@castor.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1211468567.3024.6.camel@castor.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22 2008, Richard Kennedy wrote:
> saves 8 bytes of padding & increases objects/slab from 30 to 32 on my
> AMD64 config 

Good stuff, thanks!

-- 
Jens Axboe

