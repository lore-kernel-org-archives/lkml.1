Return-Path: <linux-kernel-owner+w=401wt.eu-S1030323AbXDMXkY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030323AbXDMXkY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 19:40:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030455AbXDMXkY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 19:40:24 -0400
Received: from holomorphy.com ([66.93.40.71]:53318 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030323AbXDMXkX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 19:40:23 -0400
Date: Fri, 13 Apr 2007 16:40:10 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jason Lunz <lunz@falooley.org>, Cameron Schaus <cam@schaus.ca>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.20 OOM with 8Gb RAM
Message-ID: <20070413234010.GX2986@holomorphy.com>
References: <20070412173830.GA31323@schaus.ca> <20070412121553.c7fd3249.akpm@linux-foundation.org> <20070413223935.GA6783@metaxa.reflex> <20070413154653.21fdb914.akpm@linux-foundation.org> <20070413225433.GV2986@holomorphy.com> <20070413163242.7d9283e1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070413163242.7d9283e1.akpm@linux-foundation.org>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Apr 2007 15:54:33 -0700 William Lee Irwin III <wli@holomorphy.com> wrote:
>> After all this time, bdevs are still lowmem etc. Crying shame.

On Fri, Apr 13, 2007 at 04:32:42PM -0700, Andrew Morton wrote:
> One would need to hunt down every use of b_data in filesystems and switch
> them to kmap the page.
> Possibly it could be done on a per-fs basis.

Queued right behind a dozen other massive sweeps for me to do.


-- wli
