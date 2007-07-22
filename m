Return-Path: <linux-kernel-owner+w=401wt.eu-S1765772AbXGVLMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765772AbXGVLMS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 07:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754728AbXGVLMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 07:12:06 -0400
Received: from [212.12.190.99] ([212.12.190.99]:33634 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753576AbXGVLMD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 07:12:03 -0400
From: Al Boldi <a1426z@gawab.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] readahead drop behind and size adjustment
Date: Sun, 22 Jul 2007 14:11:59 +0300
User-Agent: KMail/1.5
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200707221411.59594.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fengguang Wu wrote:
> On Sun, Jul 22, 2007 at 10:24:37AM +0200, Peter Zijlstra wrote:
> > On Sun, 2007-07-22 at 16:10 +0800, Fengguang Wu wrote:
> > > - It will avoid large-file-reads-thrashing-my-desktop problem,
> > >   so most desktop users should like it. But sure there will be counter
> > >   cases when a user want to keep the data cached.
> > > - File servers may hurt from it. Imagine a mp3/png file server. The
> > >   files are large enough to trigger drop-behind, but small (and hot)
> > >   enough to be cached. Also when a new fedora DVD iso is released, it
> > >   may be cached for some days. These are only the obvious cases.
> > >
> > > So I opt for it being made tunable, safe, and turned off by default.
> >
> > I'm still not convinced (Rik wasn't either last time around). When these
> > files really are hot, they will be kept in memory due to them becoming
> > Active.
> >
> > Also, by scaling up the max readahead size it takes a larger file before
> > it starts dropping. If say this server has 4G of memory (not much at all
> > for a server) resulting in a 1M readahead window, the file needs to be >
> > ~2M before it starts drop behind.
>
> [snip]
>
> > But I guess it takes someone to try this IRL before we can settle this
> > debate :-/
>
> Yeah, some real workload numbers would help.

A patch against 2.6.22 may help too.


Thanks!

--
Al

