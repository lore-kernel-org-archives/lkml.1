Return-Path: <linux-kernel-owner+w=401wt.eu-S1755185AbYIOOPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185AbYIOOPn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 10:15:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751580AbYIOOPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 10:15:36 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39890 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826AbYIOOPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 10:15:35 -0400
Date: Mon, 15 Sep 2008 10:15:33 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Frederik Himpe <fhimpe@telenet.be>
Cc: linux-xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Subject: Re: XFS does not recognise mount options in 2.6.27-rc6
Message-ID: <20080915141533.GA12590@infradead.org>
References: <pan.2008.09.14.18.53.20@telenet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <pan.2008.09.14.18.53.20@telenet.be>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 14, 2008 at 06:53:21PM +0000, Frederik Himpe wrote:
> In 2.6.27-rc6, XFS still does not recognise mount options like logbufs and 
> others. Because of this, at boot time it fails to mount the partitions rw, 
> making the system unusable.
> 
> Some time ago, it seems a patch was about to be committed, but apparently 
> this has not been done yet:
> http://lkml.org/lkml/2008/8/14/340

The fix is in:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=62a877e35d5085c65936ed3194d1bbaf84f419e1

if you still see problems please give me the exact mount / remount
commands that cause you problems.

