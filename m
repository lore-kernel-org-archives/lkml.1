Return-Path: <linux-kernel-owner+w=401wt.eu-S1752663AbXCNRPG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752663AbXCNRPG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 13:15:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752637AbXCNRPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 13:15:05 -0400
Received: from smtp.osdl.org ([65.172.181.24]:46547 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752610AbXCNRPC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 13:15:02 -0400
Date: Wed, 14 Mar 2007 10:14:43 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Patrick McHardy <kaber@trash.net>
Cc: Arkadiusz Miskiewicz <arekm@maven.pl>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, lartc@mailman.ds9a.nl
Subject: Re: [ANNOUNCE] iproute2 2.6.20-070313
Message-ID: <20070314101443.4347efdd@freekitty>
In-Reply-To: <45F7EB5C.5010901@trash.net>
References: <20070313151549.332004c9@freekitty>
	<200703141223.48927.arekm@maven.pl>
	<45F7E527.6030307@trash.net>
	<200703141316.05509.arekm@maven.pl>
	<45F7EB5C.5010901@trash.net>
Organization: Linux Foundation
X-Mailer: Sylpheed-Claws 2.5.0-rc3 (GTK+ 2.10.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Mar 2007 13:32:28 +0100
Patrick McHardy <kaber@trash.net> wrote:

> Arkadiusz Miskiewicz wrote:
> > Hm, why no RTA_FWMASK in HEAD rtnetlink.h
> > 
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=include/linux/rtnetlink.h;h=4a629ea70cc4ca60a6f486f8653974af68dbe8cd;hb=HEAD
> > 
> > and 2.6.19
> > 
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=include/linux/rtnetlink.h;h=3a18addaed4ccb7436bffc9cf5fd0666f145d35c;hb=0215ffb08ce99e2bb59eca114a99499a4d06e704
> > 
> > ?
> 
> Its in include/linux/fib_rules.h:
> 
> enum
> {
> ...
>         FRA_FWMASK,     /* mask for netfilter mark */
> 
>         __FRA_MAX
> };
> 
> RTA_* attributes aren't used for routing rules anymore inside
> the kernel.

But we need to keep them in iproute2 for back compatibility?

-- 
Stephen Hemminger <shemminger@linux-foundation.org>
