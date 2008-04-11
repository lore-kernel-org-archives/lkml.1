Return-Path: <linux-kernel-owner+w=401wt.eu-S1759107AbYDKVrb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759107AbYDKVrb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 17:47:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756080AbYDKVrW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 17:47:22 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:17104 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756062AbYDKVrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 17:47:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=nq7kgUbQ95UGhNzF7wLkNnR/Za98H0TcdYyZ4Iz+bBpzEHkO0LgkmP4jhsbD7q33/hYc3OpFPbSdeORgEtlJnFS59BVLM7Rdr9RnaElcpb+Zn8Dgz55ZATcWAu9XeW/F8V4MqfpOY8UL686pAtUmhKohY/7qecF0MnU0tEKmDq8=
Date: Sat, 12 Apr 2008 01:42:57 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Bongani Hlope <bonganilinux@mweb.co.za>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Shutdown and Reboot Regression 2.6.25-rc[78]
Message-ID: <20080411214257.GA4979@martell.zuzino.mipt.ru>
References: <200804112241.44626.bonganilinux@mweb.co.za>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804112241.44626.bonganilinux@mweb.co.za>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2008 at 10:41:44PM +0200, Bongani Hlope wrote:
> I found a regression in version 2.6.25-rc7, which causes my computer not to 
> shutdown or reboot. I get a complete lock up (no keyboard and Sys-Rq) just 
> before it normally shuts down the alsa service.
> 
> I did a git bisect and it points to this reversion: 
> [266c2e0abeca649fa6667a1a427ad1da507c6375] Make printk() console semaphore 
> accesses sensible

Is it 100% reproducable? I mean sometimes I also have complete lockup right
after one of eth interfaces shutdown during shutdown sequence. And it's
also recent.

But it triggers ~1 time in 10 subjectively..

