Return-Path: <linux-kernel-owner+w=401wt.eu-S933185AbXCMUNj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933185AbXCMUNj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 16:13:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933177AbXCMUNi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 16:13:38 -0400
Received: from mtaout2.012.net.il ([84.95.2.4]:38346 "EHLO mtaout2.012.net.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933121AbXCMUNh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 16:13:37 -0400
Date: Tue, 13 Mar 2007 22:13:34 +0200
From: Avi Kivity <avi@argo.co.il>
Subject: Re: considering kevent - the kernel development process
In-reply-to: <20070313190637.GA900@infradead.org>
To: Christoph Hellwig <hch@infradead.org>,
       Johann Borck <johann.borck@densedata.com>, linux-kernel@vger.kernel.org
Message-id: <45F705EE.6040405@argo.co.il>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
X-Greylist: Sender IP whitelisted,
 not delayed by milter-greylist-2.1.12 (firebolt.argo.co.il [0.0.0.0]); Tue,
 13 Mar 2007 22:13:34 +0200 (IST)
References: <45F6F590.8030909@densedata.com>
 <20070313190637.GA900@infradead.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> It's not obvious, but utter bullshit.  Please go away if you think
> starting post with quotes from CGL specs is even remotely close to
> a good idea.
>   

I don't know about CGL, but a unified async notification mechanism _is_ 
needed.  In ~2002, I needed one, and what I ended up with was a Red Hat 
2.4 kernel with IO_CMD_POLL hacked in.  Five years later, mainline still 
can't do that.

Whether it's syslets, threadlets, io_getevents with networking support, 
kevents, epoll with kaio support, queued signals, or something else, 
users don't care, but they need _something_.  Please don't ignore the 
users just because they quote the wrong text.  The need is very real.


-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

