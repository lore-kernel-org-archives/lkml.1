Return-Path: <linux-kernel-owner+w=401wt.eu-S1763654AbXEUPKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763654AbXEUPKA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 11:10:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758261AbXEUPJv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 11:09:51 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42709 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763397AbXEUPJu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 11:09:50 -0400
Date: Mon, 21 May 2007 11:09:37 -0400
From: Dave Jones <davej@redhat.com>
To: Christoph Hellwig <hch@infradead.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, rdunlap@xenotime.net
Subject: Re: RFC: Schedule EFS for removal.
Message-ID: <20070521150937.GB6957@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Christoph Hellwig <hch@infradead.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>, rdunlap@xenotime.net
References: <20070521144618.GA6914@redhat.com> <20070521150242.GA25146@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070521150242.GA25146@infradead.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2007 at 04:02:42PM +0100, Christoph Hellwig wrote:
 > On Mon, May 21, 2007 at 10:46:18AM -0400, Dave Jones wrote:
 > > EFS aparently is broken (See http://bugzilla.kernel.org/show_bug.cgi?id=1020)
 > > has been so for some time, and attempts to fix it have been rejected.
 > > Given there's a userspace app to access these volumes, how
 > > about scheduling it for removal ?
 > 
 > It works perfectly fine, just not with the odd blocksizes on cdroms.
 > SGI Australia folks are using it for exporting their irix cdrom images
 > to various nfs systems for example, and I added that support long after
 > the bug was opened.
 > 
 > So clear NACK for this.

Ah, that woke people up :-)
Ok, patch rescinded.  Any opinion on what to do about that bug?

"use loopback" would be one option I guess.
Given its been an open bug for four years, there's obviously
not that much interest in fixing the filesystem.

	Dave

-- 
http://www.codemonkey.org.uk
