Return-Path: <linux-kernel-owner+w=401wt.eu-S1767148AbXCIKke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767148AbXCIKke (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 05:40:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767144AbXCIKke
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 05:40:34 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:37468 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767148AbXCIKkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 05:40:32 -0500
Date: Fri, 9 Mar 2007 10:40:30 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Nate Diller <nate.diller@gmail.com>
Cc: Nick Piggin <npiggin@suse.de>, Christoph Hellwig <hch@infradead.org>,
       Linux Filesystems <linux-fsdevel@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 1/3] fs: add an iovec iterator
Message-ID: <20070309104030.GB4503@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Nate Diller <nate.diller@gmail.com>, Nick Piggin <npiggin@suse.de>,
	Linux Filesystems <linux-fsdevel@vger.kernel.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
References: <20070208105437.26443.35653.sendpatchset@linux.site> <20070208105446.26443.35864.sendpatchset@linux.site> <20070208194953.GA4118@infradead.org> <20070209014626.GB17334@wotan.suse.de> <5c49b0ed0702081803o6d2ba99ct5703f76465c524f4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5c49b0ed0702081803o6d2ba99ct5703f76465c524f4@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 08, 2007 at 06:03:50PM -0800, Nate Diller wrote:
> i had a patch integrating the iodesc idea, but after some thought, had
> decided to call it struct file_io.  That name reflects the fact that
> it's doing I/O in arbitrary lengths with byte offsets, and struct
> file_io *fio contrasts well with struct bio (block_io).  I also had
> used the field ->nbytes instead of ->count, to clarify the difference
> between segment iterators, segment offsets, and absolute bytecount.

struct file_io sounds rather ugly to me, I don't know why.  And it's
really user I/O so we could call it struct uio (historical punt intended) :)

