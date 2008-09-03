Return-Path: <linux-kernel-owner+w=401wt.eu-S1755180AbYICNul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180AbYICNul (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 09:50:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752056AbYICNue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 09:50:34 -0400
Received: from paperclip.laurelnetworks.com ([63.94.127.69]:49268 "EHLO
	paperclip.laurelnetworks.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751691AbYICNud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 09:50:33 -0400
Date: Wed, 3 Sep 2008 09:50:36 -0400
From: La Monte Yarroll <piggy@laurelnetworks.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [PATCH] Provide control over core name even for multithreaded
 processes
Message-ID: <20080903095036.0331de10@kartuli>
In-Reply-To: <20080902151426.98935cd1.akpm@linux-foundation.org>
References: <20080829152215.2cdb1438@kartuli>
	<20080902151426.98935cd1.akpm@linux-foundation.org>
Organization: Systems
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Sep 2008 15:14:26 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 29 Aug 2008 15:22:15 -0400
> "La Monte H.P. Yarroll" <piggy@laurelnetworks.com> wrote:
> 
> > Our system explicitly sets core_pattern to force a relatively small
> > limit on the number of different core dump names.
> > 
> > Unfortunately, the kernel unconditionally appends .<tid> for
> > multithreaded processes.
> > 
> > The attached patch introduces "%T" to the core_pattern language,
> > which expands to ".<tid>" for multithreaded processes. It then
> > changes the default core_pattern to "core%T" replicating the
> > current default behavior.
> > 
> > Signed-off-by: La Monte H.P. Yarroll <piggy@laurelnetworks.com>
> > 74-256740
...
> 
> Please review Oleg's
> http://userweb.kernel.org/~akpm/mmotm/broken-out/coredump-format_corename-dont-append-%25pid-if-multi-threaded.patch,
> which I have queued for 2.6.28.

Thanks! This is even better and looks like it meets our needs.
