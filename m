Return-Path: <linux-kernel-owner+w=401wt.eu-S1754406AbZEWMkr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754406AbZEWMkr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 08:40:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751825AbZEWMkk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 08:40:40 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40841 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbZEWMkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 08:40:39 -0400
Date: Sat, 23 May 2009 08:40:18 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jeff Moyer <jmoyer@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Jens Axboe <jens.axboe@oracle.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>, "Theodore Ts'o" <tytso@mit.edu>,
       Steven Whitehouse <swhiteho@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] convert block trace points to TRACE_EVENT()
Message-ID: <20090523124018.GA15163@infradead.org>
References: <4A0BB813.9080807@cn.fujitsu.com> <x49ws8d45am.fsf@segfault.boston.devel.redhat.com> <20090519130841.GA3801@infradead.org> <4A13C19E.3000303@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A13C19E.3000303@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 20, 2009 at 04:38:54PM +0800, Li Zefan wrote:
> Yes, this patch doesn't affect ioctl-based blktrace or ftrace-plugin
> blktrace at all.

Is there any good reason for keeping the ftrace plugin once we have
the fully function event tracer support for the block events?

