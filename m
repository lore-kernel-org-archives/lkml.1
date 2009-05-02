Return-Path: <linux-kernel-owner+w=401wt.eu-S1755618AbZEBHT4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755618AbZEBHT4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 03:19:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752070AbZEBHTr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 03:19:47 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55568 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895AbZEBHTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 03:19:47 -0400
Date: Sat, 2 May 2009 03:19:39 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jan Blunck <jblunck@suse.de>
Subject: Re: [PATCH] driver-core: devtmpfs - driver core maintained /dev
	tmpfs
Message-ID: <20090502071939.GA14094@infradead.org>
References: <1241097822.2516.3.camel@poy> <20090430222900.c13b63d5.akpm@linux-foundation.org> <20090501061701.GB19234@kroah.com> <20090430234312.a63fa5cf.akpm@linux-foundation.org> <20090501065527.GA19773@kroah.com> <20090501120359.05bacb48@lxorguk.ukuu.org.uk> <ac3eb2510905010411r2c1a2be5s449aaf485a76a8c4@mail.gmail.com> <20090501141846.4b833700@lxorguk.ukuu.org.uk> <ac3eb2510905010624k891f680s7255af8ae185b5d5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac3eb2510905010624k891f680s7255af8ae185b5d5@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 01, 2009 at 03:24:01PM +0200, Kay Sievers wrote:
> I'm very sure, you can not fix it outside the kernel. Or do you have
> an idea how to create the missing device nodes for device without
> crawling sysfs, when the first userspace process is started?

Just make sure to queue up your uevents in a ring buffer that udev
can read once it has started?

