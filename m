Return-Path: <linux-kernel-owner+w=401wt.eu-S1752035AbZEXI52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035AbZEXI52 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 04:57:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751596AbZEXI5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 04:57:21 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58275 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbZEXI5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 04:57:20 -0400
Date: Sun, 24 May 2009 04:57:01 -0400
From: Christoph Hellwig <hch@infradead.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Hellwig <hch@infradead.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Jeff Moyer <jmoyer@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Jens Axboe <jens.axboe@oracle.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>, "Theodore Ts'o" <tytso@mit.edu>,
       Steven Whitehouse <swhiteho@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] convert block trace points to TRACE_EVENT()
Message-ID: <20090524085701.GA4302@infradead.org>
References: <4A13C19E.3000303@cn.fujitsu.com> <20090523124018.GA15163@infradead.org> <20090524141347.0841.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090524141347.0841.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 24, 2009 at 02:15:05PM +0900, KOSAKI Motohiro wrote:
> > Is there any good reason for keeping the ftrace plugin once we have
> > the fully function event tracer support for the block events?
> 
> waiting userland blktrace tool convert using event tracer? 

blktrace(8) uses the ioctl interface, which we should keep for a long
time for backwards compatiblity.  

