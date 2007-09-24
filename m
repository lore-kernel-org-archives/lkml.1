Return-Path: <linux-kernel-owner+w=401wt.eu-S1762644AbXIXSXP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762644AbXIXSXP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 14:23:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761679AbXIXSW4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 14:22:56 -0400
Received: from tomts5-srv.bellnexxia.net ([209.226.175.25]:60787 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760412AbXIXSWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 14:22:55 -0400
Date: Mon, 24 Sep 2007 14:22:53 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Christoph Hellwig <hch@infradead.org>,
       "Robert P. J. Day" <rpjday@mindspring.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, "Frank Ch. Eigler" <fche@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [patch 4/7] Linux Kernel Markers - Architecture Independent Code
Message-ID: <20070924182252.GA30059@Krystal>
References: <20070924164950.006047409@polymtl.ca> <20070924165427.717587684@polymtl.ca> <20070924174817.GB1608@infradead.org> <Pine.LNX.4.64.0709241413450.22210@localhost.localdomain> <20070924181947.GB3810@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070924181947.GB3810@infradead.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:22:45 up 56 days, 18:41,  7 users,  load average: 1.19, 1.23, 1.07
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Hellwig (hch@infradead.org) wrote:
> On Mon, Sep 24, 2007 at 02:15:12PM -0400, Robert P. J. Day wrote:
> > On Mon, 24 Sep 2007, Christoph Hellwig wrote:
> > 
> > > static inline void __mark_check_format(const char *fmt, ...)
> > > 		__attribute__ ((format (printf, 1, 2)))
> > > {
> > > }
> > 
> > the header file compiler-gcc.h defines the shorter macro "__printf".
> > is it worth encouraging its use, or does it matter?
> 
> Yes, that's even better.

Ok, fixing.

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
