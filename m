Return-Path: <linux-kernel-owner+w=401wt.eu-S1750882AbXDLXCi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750882AbXDLXCi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 19:02:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752000AbXDLXCi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 19:02:38 -0400
Received: from mail.suse.de ([195.135.220.2]:35946 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882AbXDLXCh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 19:02:37 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH UPDATE] deflate stack usage in lib/inflate.c
Date: Fri, 13 Apr 2007 01:02:30 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Tim Yamin <plasmaroo@gentoo.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <461DED14.1070603@goop.org> <200704122321.23318.ak@suse.de> <461EB938.6080807@goop.org>
In-Reply-To: <461EB938.6080807@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704130102.30588.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 13 April 2007 00:56:56 Jeremy Fitzhardinge wrote:
> Andi Kleen wrote:
> >> (This was under Xen, but there's no reason it couldn't happen on bare
> >>   hardware.)
> >>     
> >
> > Hmm, does Xen perhaps not use interrupt stacks?
> 
> Looks like that's all done in do_IRQ, so it should be independent of
> whether its Xen or not.  And the stack overflow check is performed on
> the main stack, before switching to the interrupt stack.

Yes, but then we should have seen more frequently, shouldn't we? I always
run with the stack overflow check enabled and I don't think I ever saw 
warnings in inflate.

Something must be different in the Xen setup. Dunno if it's a bug,
but such differences could cause more problems later.

-Andi



