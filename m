Return-Path: <linux-kernel-owner+w=401wt.eu-S1761175AbXGMArf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761175AbXGMArf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 20:47:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755200AbXGMAr2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 20:47:28 -0400
Received: from mailgw.voltaire.com ([193.47.165.252]:56526 "EHLO
	mailgw.voltaire.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754867AbXGMAr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 20:47:28 -0400
X-Greylist: delayed 1620 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Jul 2007 20:47:27 EDT
Subject: Re: [ofa-general] Further 2.6.23 merge plans...
From: Hal Rosenstock <halr@voltaire.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: linux-kernel@vger.kernel.org, general@lists.openfabrics.org
In-Reply-To: <adahco943ip.fsf@cisco.com>
References: <adalkdl43w0.fsf@cisco.com>  <adahco943ip.fsf@cisco.com>
Content-Type: text/plain
Organization: 
Message-Id: <1184285856.13276.34352.camel@hal.voltaire.com>
Mime-Version: 1.0
X-Mailer: Ximian Evolution 1.2.2 (1.2.2-4) 
Date: 12 Jul 2007 20:17:37 -0400
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-07-12 at 19:15, Roland Dreier wrote:
> As you can see, I just sent my first 2.6.23 pull request for Linus.
> There are still a few more things I plan to do in before the merge
> window closes (in ~10 days):
> 
>  - Write a patch to add P_Key handling to user_mad in the way we
>    discussed (add an ioctl to enable P_Key mode without breaking old
>    apps) -- I hope to do this tomorrow so we can get some review and
>    testing before merging it.

Unfortunately, I'll mostly just be able to review it. Not sure how much
testing I will be able to do but we'll see...

-- Hal

>  - Take a look at Sean's local SA caching patches.  I merged
>    everything else from Sean's tree, but I'm still undecided about
>    these.  I haven't read them carefully yet, but even aside from that
>    I don't have a good feeling about whether there's consensus about
>    this yet.  Any opinions about merging, for or against, would be
>    appreciated here.
> 
>  - Merge up pending hardware driver changes, including the cxgb3 and
>    ehca patches I have in my queue, plus Jack's catastrophic error
>    patch for mlx4.
> 
>  - Try to get to resolution on the IPoIB "CM without SRQ" solution.
> 
> Also, if there's something I didn't list and didn't already include in
> the tree I asked Linus to pull, please remind me.  I probably dropped it.
> 
>  - R.
> _______________________________________________
> general mailing list
> general@lists.openfabrics.org
> http://lists.openfabrics.org/cgi-bin/mailman/listinfo/general
> 
> To unsubscribe, please visit http://openib.org/mailman/listinfo/openib-general

