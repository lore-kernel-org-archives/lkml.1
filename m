Return-Path: <linux-kernel-owner+w=401wt.eu-S1753726AbZAFXY6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726AbZAFXY6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 18:24:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754144AbZAFXYm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 18:24:42 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:60312 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754118AbZAFXYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 18:24:40 -0500
Date: Tue, 6 Jan 2009 18:24:39 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>
Subject: Re: 2.6.29 -mm merge plans
Message-ID: <20090106232439.GC25103@infradead.org>
References: <20090105004300.19ed52d1.akpm@linux-foundation.org> <20090106225744.GA10553@infradead.org> <20090106151344.0f146286.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090106151344.0f146286.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2009 at 03:13:44PM -0800, Andrew Morton wrote:
> (cc added)
> 
> On Tue, 6 Jan 2009 17:57:44 -0500
> Christoph Hellwig <hch@infradead.org> wrote:
> 
> > On Mon, Jan 05, 2009 at 12:43:00AM -0800, Andrew Morton wrote:
> > 
> > > softirq-introduce-statistics-for-softirq.patch
> > > proc-export-statistics-for-softirq-to-proc.patch
> > > proc-update-document-for-proc-softirqs-and-proc-stat.patch
> > 
> > Why is this in procfs?
> 
> softirq stuff in /proc seems appropriate?  It's alongside
> /proc/interrupts.  We could put it in /trendy-fs-of-the-day, but what
> would it gain us?

debugfs seems to be the normal thing for these.

