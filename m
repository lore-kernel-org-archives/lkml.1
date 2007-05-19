Return-Path: <linux-kernel-owner+w=401wt.eu-S1763738AbXESMUJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763738AbXESMUJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 08:20:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758209AbXESMT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 08:19:58 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34869 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757865AbXESMT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 08:19:57 -0400
Date: Sat, 19 May 2007 14:19:56 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, Jens Axboe <jens.axboe@oracle.com>,
       Oleg Nesterov <oleg@tv-sign.ru>, Steven Pratt <slpratt@austin.ibm.com>,
       Ram Pai <linuxram@us.ibm.com>
Subject: Re: [PATCH 8/9] readahead: convert ext3/ext4 invocations
Message-ID: <20070519121956.GD25563@one.firstfloor.org>
References: <20070516224752.500812933@mail.ustc.edu.cn> <20070516224819.281192313@mail.ustc.edu.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070516224819.281192313@mail.ustc.edu.cn>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2007 at 06:48:00AM +0800, Fengguang Wu wrote:
> Convert ext3/ext4 dir reads to use on-demand readahead.
> 
> Readahead for dirs operates _not_ on file level, but on blockdev level.
> This makes a difference when the data blocks are not continuous.
> And the read routine is somehow opaque: there's no handy info about the status
> of current page. So a simplified call scheme is employed: to call into
> readahead whenever the current page falls out of readahead windows.

ext2 too would be nice. Also when it goes in it might be worth
contacting linux-fsdevel with a quick pointer to this so that other
file systems can possibly benefit too.
-Andi

