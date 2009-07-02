Return-Path: <linux-kernel-owner+w=401wt.eu-S1753724AbZGBM3d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753724AbZGBM3d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 08:29:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752595AbZGBM3Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 08:29:25 -0400
Received: from mx-out2.daemonmail.net ([216.104.160.39]:45259 "EHLO
	mx-out2.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580AbZGBM3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 08:29:25 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Joe Perches <joe@perches.com>
Subject: Re: printk regression?
Date: Thu, 2 Jul 2009 07:29:21 -0500
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <4A4C3410.8080704@kernel.org> <alpine.LFD.2.01.0907012119370.3380@localhost.localdomain> <1246513356.28915.62.camel@Joe-Laptop.home>
In-Reply-To: <1246513356.28915.62.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907020729.23976.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu July 2 2009, Joe Perches wrote:
> On Wed, 2009-07-01 at 21:23 -0700, Linus Torvalds wrote:
> > 
> > On Wed, 1 Jul 2009, Yinghai Lu wrote:
> > >
> > > [   75.690022] <7>printing local APIC contents on CPU#0/0:
> > 
> > Yes. This is because the io_apic code should be fixed.
> > 
> > It does:
> > 
> > 	printk("\n" KERN_DEBUG "printing local APIC
> > 
> > and that "\n" at the beginning should just be deleted. The log-level 
> > should be at the beginning of the printk, not in the middle.
> 
> There's at least 72 of them:
> 
> $ grep -Pr --include=*.[ch] "\bprintk.*\\\n.*KERN_" *
> 

That should qualify it as a documented feature.  ;)
"To convert the log level marker into visible garbage, do..."

Mike
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 


