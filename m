Return-Path: <linux-kernel-owner+w=401wt.eu-S1753752AbZEXNsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752AbZEXNsj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 09:48:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751907AbZEXNsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 09:48:32 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36318 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbZEXNsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 09:48:31 -0400
Date: Sun, 24 May 2009 22:47:31 +0900 (JST)
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC][PATCH] convert block trace points to TRACE_EVENT()
Cc: kosaki.motohiro@jp.fujitsu.com, Li Zefan <lizf@cn.fujitsu.com>,
       Jeff Moyer <jmoyer@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Jens Axboe <jens.axboe@oracle.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>, "Theodore Ts'o" <tytso@mit.edu>,
       Steven Whitehouse <swhiteho@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090524085701.GA4302@infradead.org>
References: <20090524141347.0841.A69D9226@jp.fujitsu.com> <20090524085701.GA4302@infradead.org>
Message-Id: <20090524224509.0855.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sun, May 24, 2009 at 02:15:05PM +0900, KOSAKI Motohiro wrote:
> > > Is there any good reason for keeping the ftrace plugin once we have
> > > the fully function event tracer support for the block events?
> > 
> > waiting userland blktrace tool convert using event tracer? 
> 
> blktrace(8) uses the ioctl interface, which we should keep for a long
> time for backwards compatiblity.  

Ah, I misunderstand your point. sorry.
I though you suggested to remove ioctl. but it's reverse. ok. :)

So, I guess same formatting make easy understanding for administrator, maybe.





