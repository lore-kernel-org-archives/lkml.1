Return-Path: <linux-kernel-owner+w=401wt.eu-S1755901AbXK1F2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901AbXK1F2k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 00:28:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750898AbXK1F2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 00:28:30 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39775 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750805AbXK1F23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 00:28:29 -0500
Date: Tue, 27 Nov 2007 21:28:05 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Robert Hancock <hancockr@shaw.ca>
Cc: bdupree@techfinesse.com, linux-kernel@vger.kernel.org
Subject: Re: Dynticks Causing High Context Switch Rate in ksoftirqd
Message-Id: <20071127212805.31f0de96.akpm@linux-foundation.org>
In-Reply-To: <474B9EC1.5020304@shaw.ca>
References: <fa.c70Wy8WHP3DOaDydQ2D94+Xxx/8@ifi.uio.no>
	<474B9EC1.5020304@shaw.ca>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Nov 2007 22:36:17 -0600 Robert Hancock <hancockr@shaw.ca> wrote:

> bdupree@techfinesse.com wrote:
> > Question: Why is ksoftirqd eating about 5 to 10 percent of my CPU on an idle
> > system? The problem occurs if I config the kernel with tickless
> > support (i.e. CONFIG_TICK_ONESHOT=y).  (Thanks to "oprofile" for putting me
> > onto this.)
> > 
> > I have noted this same problem on kernel versions: 2.6.23.1, 2.6.23.8 and
> > 2.6.23.9
> > 
> > **************************************************************************
> > *** Output from "vmstat -n 1 10" -- Note very high context switch rate ***
> > *** This is on a idle machine!                                         ***
> > **************************************************************************
> > 
> > procs -----------memory---------- ---swap-- -----io---- --system--
> > ----cpu----
> >  r  b   swpd   free   buff  cache   si   so    bi    bo   in    cs us sy
> > id wa
> >  0  0      0 1925556   4768 116104    0    0   124     2    6  7538  1  2
> > 96  1
> >  0  0      0 1925556   4768 116104    0    0     0     0    2 147329  0  1
> > 99  0
> 
> What did oprofile show? It should be able to narrow down what 
> function(s) are responsible for the CPU usage..

Sigh.  I just asked a similar thing.   Let's look at the mail headers:



Message-ID: <41877.67.173.156.207.1196130992.squirrel@www.techfinesse.net>
...
From: bdupree@techfinesse.com


From: Robert Hancock <hancockr@shaw.ca>
...
In-reply-to: <fa.c70Wy8WHP3DOaDydQ2D94+Xxx/8@ifi.uio.no>


Please fix your email client so as to not break threading?
