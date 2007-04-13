Return-Path: <linux-kernel-owner+w=401wt.eu-S965663AbXDMWy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965663AbXDMWy3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 18:54:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965672AbXDMWy2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 18:54:28 -0400
Received: from holomorphy.com ([66.93.40.71]:51241 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965663AbXDMWy2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 18:54:28 -0400
Date: Fri, 13 Apr 2007 15:54:33 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jason Lunz <lunz@falooley.org>, Cameron Schaus <cam@schaus.ca>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.20 OOM with 8Gb RAM
Message-ID: <20070413225433.GV2986@holomorphy.com>
References: <20070412173830.GA31323@schaus.ca> <20070412121553.c7fd3249.akpm@linux-foundation.org> <20070413223935.GA6783@metaxa.reflex> <20070413154653.21fdb914.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070413154653.21fdb914.akpm@linux-foundation.org>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2007 at 03:46:53PM -0700, Andrew Morton wrote:
> It's just weird - it exploits internal knowledge of VFS behaviour, diddles
> with pagecache within a fake disk strategy handler, etc.
> Furthermore, because it pretends to be a block device, the VFS will not use
> highmem pages when accessing the ramdisk.  So the 8GB machine will go splat
> with only 800MB of ramdisk.
> ramfs is much cleaner and does not have that limitation.

After all this time, bdevs are still lowmem etc. Crying shame.


-- wli
