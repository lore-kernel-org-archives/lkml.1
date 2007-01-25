Return-Path: <linux-kernel-owner+w=401wt.eu-S965594AbXAYGkd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965594AbXAYGkd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 01:40:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965606AbXAYGkd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 01:40:33 -0500
Received: from [212.12.190.178] ([212.12.190.178]:32882 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S965594AbXAYGkc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 01:40:32 -0500
From: Al Boldi <a1426z@gawab.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [RFC] Limit the size of the pagecache
Date: Thu, 25 Jan 2007 09:42:47 +0300
User-Agent: KMail/1.5
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200701250942.47321.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel wrote:
> Christoph Lameter wrote:
> > This is a patch using some of Aubrey's work plugging it in what is IMHO
> > the right way. Feel free to improve on it. I have gotten repeatedly
> > requests to be able to limit the pagecache.
>
> IMHO it's a bad hack.
>
> It would be better to identify the problem this "feature" is
> trying to fix, and then fix the root cause.

Ok, here is the problem:  kswapd.

Limiting the page-cache memory inhibits invoking kswapd needlessly, aiding 
performance and easing OOM pressures.

I tried the patch; it works.

But it needs a bit of debugging.  Setting pagecache_ratio = 1 either 
deadlocks or reduces thru-put to < 1mb/s.


Thanks!

--
Al

