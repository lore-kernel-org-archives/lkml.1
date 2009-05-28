Return-Path: <linux-kernel-owner+w=401wt.eu-S1753151AbZE1W11@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151AbZE1W11 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 18:27:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751277AbZE1W1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 18:27:18 -0400
Received: from brick.kernel.dk ([93.163.65.50]:37122 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751109AbZE1W1R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 18:27:17 -0400
Date: Fri, 29 May 2009 00:27:18 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Artem Bityutskiy <dedekind1@gmail.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, tytso@mit.edu, chris.mason@oracle.com,
       david@fromorbit.com, hch@infradead.org, akpm@linux-foundation.org,
       jack@suse.cz, yanmin_zhang@linux.intel.com, richard@rsk.demon.co.uk,
       damien.wyart@free.fr
Subject: Re: [PATCH 0/11] Per-bdi writeback flusher threads v9
Message-ID: <20090528222718.GE11363@kernel.dk>
References: <1243511204-2328-1-git-send-email-jens.axboe@oracle.com> <4A1E9D0B.4090402@gmail.com> <4A1E9D8B.8020908@gmail.com> <1243542908.6645.104.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1243542908.6645.104.camel@laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 28 2009, Peter Zijlstra wrote:
> On Thu, 2009-05-28 at 17:19 +0300, Artem Bityutskiy wrote:
> > Artem Bityutskiy wrote:
> > > question is - should it? 'bdi_register()' a block device,
> > > but we do not have one.
> > 
> > Sorry, wanted to say: 'bdi_register()' registers a block
> > device.
> 
> BDI stands for backing device info and is not related to block devices
> other than that block devices can also be (ok, always are) backing
> devices.
> 
> If you want to do writeback, you need a backing device to write to. The
> BDI is the device abstraction for writeback.

Precisely. Apparently ubifs doesn't register its backing device. I fixed
a similar issue in btrfs, I'll do an audit of the file systems and fix
that up.

-- 
Jens Axboe

