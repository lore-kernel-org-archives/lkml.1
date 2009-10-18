Return-Path: <linux-kernel-owner+w=401wt.eu-S1755400AbZJRWSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400AbZJRWSr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 18:18:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755364AbZJRWSq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 18:18:46 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:48419 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755215AbZJRWSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 18:18:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=G1ALZA7yVenglsfLZ5B0WyJtxLsywVwXYTlnwNof53QPjy2o64ldW5dBvVHgwbT2TA
         U9m/RSn4wVfUkQc0qviSw0z7wgNw7HcnHOMnpJfqOafzlnVS0asjKWjPIYsIWP7lyG9b
         yKpIBpGnSvOlW7aUbloUiMwOSNkcYwHNa53tA=
Date: Mon, 19 Oct 2009 00:18:44 +0200
From: Karol Lewandowski <karol.k.lewandowski@gmail.com>
To: Karol Lewandowski <karol.k.lewandowski@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
       stable <stable@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       David Miller <davem@davemloft.net>, Frans Pop <elendil@planet.nl>,
       reinette chatre <reinette.chatre@intel.com>,
       Kalle Valo <kalle.valo@iki.fi>,
       "John W. Linville" <linville@tuxdriver.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 0/2] Reduce number of GFP_ATOMIC allocation failures
Message-ID: <20091018221844.GA2061@bizet.domek.prywatny>
References: <1255689446-3858-1-git-send-email-mel@csn.ul.ie> <20091017183421.GA3370@bizet.domek.prywatny>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091017183421.GA3370@bizet.domek.prywatny>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 17, 2009 at 08:34:21PM +0200, Karol Lewandowski wrote:

> I'll go now for another round of bisecting... and hopefully this time
> I'll be able to trigger this problem on different/faster computer with
> e100-based card.

No luck with that either.

I've tried merging 'akpm' (517d08699b25) into clean 2.6.30 tree and
got suspend-breakage which makes it untestable for me.  (I've tried
reverting drm, suspend, and other commits... all that failed.)

Is there mm-related git tree hidden somewhere?  ... or broken out
mm-related patches that were sent to Andrew ... or maybe it's possible
to get "git log -p" from Mel's private repo?  Anything?

Thanks.


