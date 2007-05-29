Return-Path: <linux-kernel-owner+w=401wt.eu-S1756299AbXE2RGn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756299AbXE2RGn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 13:06:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762040AbXE2RGV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 13:06:21 -0400
Received: from [206.168.112.78] ([206.168.112.78]:34519 "EHLO
	mail.clusterfs.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1762015AbXE2RGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 13:06:20 -0400
Date: Tue, 29 May 2007 19:06:10 +0200
From: Johann Lombardi <johann@clusterfs.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Clear PG_error before reading a page
Message-ID: <20070529170610.GB15502@chiva>
Mail-Followup-To: Johann Lombardi <johann@clusterfs.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <20070515143726.GC2160@chiva> <20070515101144.f7072476.akpm@linux-foundation.org> <20070515210124.GA23698@chiva> <20070515142339.4d9098f3.akpm@linux-foundation.org> <20070516153919.GC2630@chiva> <20070516091217.b9bb5797.akpm@linux-foundation.org> <20070517114250.GA2141@chiva> <20070517094730.5cdfaa64.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070517094730.5cdfaa64.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2007 at 09:47:30AM -0700, Andrew Morton wrote:
> So running ioctl(BLKFLSBUF) against the device will fix things up?

No, 'blockdev --flushbufs /dev/sdb' doesn't help.

> Perhaps not, and we should invalidate all the file data as well. The
> only ways we have of doing that are umount+mount or /proc/sys/vm/drop_caches.

'echo > /proc/sys/vm/drop_caches' works. Thanks.

Johann
