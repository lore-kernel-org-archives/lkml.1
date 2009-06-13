Return-Path: <linux-kernel-owner+w=401wt.eu-S1761282AbZFMAD3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761282AbZFMAD3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 20:03:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755987AbZFMADR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 20:03:17 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:58378 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757464AbZFMADQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 20:03:16 -0400
Subject: Re: -git tree build failure in drivers/net/cnic.c: undefined
 reference to `ip6_route_output'
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: David Miller <davem@davemloft.net>
Cc: randy.dunlap@oracle.com, mingo@elte.hu, linux-kernel@vger.kernel.org,
       mchan@broadcom.com, torvalds@linux-foundation.org
In-Reply-To: <20090612.165108.110857018.davem@davemloft.net>
References: <20090612184343.GA11900@elte.hu> <4A32A1E4.8080708@oracle.com>
	 <20090612.165108.110857018.davem@davemloft.net>
Content-Type: text/plain
Date: Sat, 13 Jun 2009 00:03:13 +0000
Message-Id: <1244851393.26552.1.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-12 at 16:51 -0700, David Miller wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> Date: Fri, 12 Jun 2009 11:43:48 -0700
> 
> > Ingo Molnar wrote:
> >> today's -git fails to build with ipv6 disabled (x86):
> >> 
> >>   drivers/built-in.o: In function `cnic_get_v6_route':
> >>   cnic.c:(.text+0x104c42): undefined reference to `ip6_route_output'
> >> 
> >> introduced by this new driver:
> >> 
> >>   a463696: [SCSI] cnic: Add new Broadcom CNIC driver.
> > 
> > I just posted a patch for this to netdev and it was acked by its maintainer.
> > Patch is below.
> 
> I was hoping the scsi folks, or Linus directly, would pick this up.

I can, but my first tree's just gone ... the next one won't be going
until nearer the merge window.

> But I can take it in too if it slips through the cracks.

That's fine by me too ... If you had a net tree ready, that would be
great ... if not, I'll add it to the next SCSI tree to go.

James


