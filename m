Return-Path: <linux-kernel-owner+w=401wt.eu-S1756479AbZBGDAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756479AbZBGDAz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 22:00:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753222AbZBGDAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 22:00:44 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40809 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752943AbZBGDAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 22:00:43 -0500
Date: Fri, 6 Feb 2009 19:00:07 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Parag Warudkar <parag.lkml@gmail.com>,
       Matt Carlson <mcarlson@broadcom.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: 2.6.29-rc3: tg3 dead after resume
In-Reply-To: <200902040141.15920.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.0902061858120.3048@localhost.localdomain>
References: <alpine.DEB.2.00.0901281858380.5048@parag-desktop> <200902032315.27113.rjw@sisk.pl> <alpine.DEB.2.00.0902031937070.7758@parag-laptop> <200902040141.15920.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 4 Feb 2009, Rafael J. Wysocki wrote:

> On Wednesday 04 February 2009, Parag Warudkar wrote:
> > 
> > On Tue, 3 Feb 2009, Rafael J. Wysocki wrote:
> > 
> > > 
> > > Can you also test this one instead and tell me if it still works?
> > 
> > Removing Linus' patch and applying the below one works as well.
> 
> Great, thanks for testing.
> 
> I'm going to push this one to Jesse.

Jesse, should I take this directly (and presumably the related series by 
Rafael)?

I was going to release -rc4 this weekend (it's already more than a week - 
I'm bad), and I'd hate for pci-e bridges to not resume correctly. So I'd 
either like a pull request from you with the pending suspend fixes, or 
I'll just apply the patch(es) directly.

		Linus
