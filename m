Return-Path: <linux-kernel-owner+w=401wt.eu-S1762327AbXEUPCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762327AbXEUPCv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 11:02:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757357AbXEUPCp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 11:02:45 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:37117 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756746AbXEUPCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 11:02:44 -0400
Date: Mon, 21 May 2007 16:02:42 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
       rdunlap@xenotime.net
Subject: Re: RFC: Schedule EFS for removal.
Message-ID: <20070521150242.GA25146@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, rdunlap@xenotime.net
References: <20070521144618.GA6914@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070521144618.GA6914@redhat.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2007 at 10:46:18AM -0400, Dave Jones wrote:
> EFS aparently is broken (See http://bugzilla.kernel.org/show_bug.cgi?id=1020)
> has been so for some time, and attempts to fix it have been rejected.
> Given there's a userspace app to access these volumes, how
> about scheduling it for removal ?

It works perfectly fine, just not with the odd blocksizes on cdroms.
SGI Australia folks are using it for exporting their irix cdrom images
to various nfs systems for example, and I added that support long after
the bug was opened.

So clear NACK for this.
