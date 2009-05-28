Return-Path: <linux-kernel-owner+w=401wt.eu-S1753377AbZE1W2P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377AbZE1W2P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 18:28:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751515AbZE1W2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 18:28:00 -0400
Received: from brick.kernel.dk ([93.163.65.50]:37137 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751277AbZE1W2A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 18:28:00 -0400
Date: Fri, 29 May 2009 00:28:01 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, tytso@mit.edu,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com,
       richard@rsk.demon.co.uk, damien.wyart@free.fr
Subject: Re: [PATCH 04/11] writeback: switch to per-bdi threads for
	flushing  data
Message-ID: <20090528222801.GF11363@kernel.dk>
References: <1243511204-2328-1-git-send-email-jens.axboe@oracle.com> <1243511204-2328-5-git-send-email-jens.axboe@oracle.com> <4A1E9C13.7030406@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A1E9C13.7030406@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 28 2009, Artem Bityutskiy wrote:
> Jens Axboe wrote:
>> +#define BDI_CAP_FLUSH_FORKER	0x00000200
>
> Would it please be possible to add a comment about
> what this flag is, and whether it is for internal
> usage or not. Not immediately obvious for me.

It's internal, probably I should just replace it with a check for
&default_backing_dev_info. If not, I'll add a comment.

-- 
Jens Axboe

