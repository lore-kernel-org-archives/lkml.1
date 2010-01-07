Return-Path: <linux-kernel-owner+w=401wt.eu-S1753411Ab0AGSfx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411Ab0AGSfx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 13:35:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752113Ab0AGSfw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 13:35:52 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:57360 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084Ab0AGSfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 13:35:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TxIRaixmlCBEuAT67CMWfvmGBKdxPcuM0C1fZC9vjxjeGTq6WQ2583adITKRHR0Nv1
         wv0xJF51tGRduUSZRWWlugya7Ikr/Dg8+4SwcwTj6HYmM9+xBpYPeyyI+8cS59VI84Fj
         1sW6vDGK8YcG1HGLnwj4jcTq37hkcLajtyux4=
Date: Thu, 7 Jan 2010 19:35:45 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: Michael Breuer <mbreuer@majjas.com>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       flyboy@gmail.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] af_packet: Don't use skb after dev_queue_xmit()
Message-ID: <20100107183545.GA3208@del.dom.local>
References: <4B455C62.6030504@majjas.com>
 <20100106205343.5460d658@nehalam>
 <4B4571D5.30002@majjas.com>
 <4B457711.1040008@majjas.com>
 <4B458B36.6050509@majjas.com>
 <20100107074756.GB6258@ff.dom.local>
 <4B459368.2000503@majjas.com>
 <4B45F841.8030407@majjas.com>
 <20100107180114.GB3088@del.dom.local>
 <4B4625BD.3070202@majjas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B4625BD.3070202@majjas.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 07, 2010 at 01:19:41PM -0500, Michael Breuer wrote:
> On 1/7/2010 1:01 PM, Jarek Poplawski wrote:
> >On Thu, Jan 07, 2010 at 10:05:37AM -0500, Michael Breuer wrote:
> >>Bad news - crashed about an hour after I wrote this email - under
> >>load - same crash as before. Network watchdog... lots of attempts to
> >>reset the adapter... then hw watchdog rebooted the system.
> >It's a pity. Anyway, I'd be still interested in CONFIG_PACKET_MMAP off
> >if you find time.
> >
> >Jarek P.
> Ok - any particular patch set to try with? I'm going to start with a
> clean tree using the latest 2.6.32 from git (tried 2.6.33-rc3, but
> can't get a usable console... will look at that later.)

My "Berck E. Nash" and Stephen's "pskb_may_pull" sky2 patches. (BTW,
could you remind if it worked any better with 2.6.31 or earlier?)

Jarek P.
