Return-Path: <linux-kernel-owner+w=401wt.eu-S938071AbXG1DnM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938071AbXG1DnM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 23:43:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933484AbXG1Dm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 23:42:57 -0400
Received: from main.gmane.org ([80.91.229.2]:54264 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761854AbXG1Dm4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 23:42:56 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Daniel Cheng <gmane@sdiz.net>
Subject: Re: -mm merge plans for 2.6.23
Date: Sat, 28 Jul 2007 11:42:43 +0800
Message-ID: <46AABB33.1080301@sdiz.net>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>	<9a8748490707231608h453eefffx68b9c391897aba70@mail.gmail.com>	<46A57068.3070701@yahoo.com.au>	<2c0942db0707232153j3670ef31kae3907dff1a24cb7@mail.gmail.com>	<46A58B49.3050508@yahoo.com.au>	<2c0942db0707240915h56e007e3l9110e24a065f2e73@mail.gmail.com>	<46A6CC56.6040307@yahoo.com.au> <46A6D7D2.4050708@gmail.com>	<1185341449.7105.53.camel@perkele> <46A6E1A1.4010508@yahoo.com.au>	<2c0942db0707250909r435fef75sa5cbf8b1c766000b@mail.gmail.com> <20070725215717.df1d2eea.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=Big5-HKSCS
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
Cc: ck@vds.kolivas.org, linux-mm@kvack.org
X-Gmane-NNTP-Posting-Host: n219079086056.netvigator.com
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070622)
In-Reply-To: <20070725215717.df1d2eea.akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
[...]
> 
> And userspace can do a much better implementation of this
> how-to-handle-large-load-shifts problem, because it is really quite
> complex.  The system needs to be monitored to determine what is the "usual"
[...]
> All this would end up needing runtime configurability and tweakability and
> customisability.  All standard fare for userspace stuff - much easier than
> patching the kernel.

But a patch already exist.
Which is easier: (1) apply the patch ; or (2) write a new patch?

> 
> So.  We can
> a) provide a way for userspace to reload pagecache and
> b) merge maps2 (once it's finished) (pokes mpm)
> and we're done?

might be.
but merging maps2 have higher risk which should be done in a development
branch (er... 2.7, but we don't have it now).

-- 

