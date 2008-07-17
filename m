Return-Path: <linux-kernel-owner+w=401wt.eu-S932086AbYGQXVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932086AbYGQXVw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 19:21:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760859AbYGQXVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 19:21:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45462 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760821AbYGQXVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 19:21:09 -0400
Date: Thu, 17 Jul 2008 16:20:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Magnus Damm" <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de
Subject: Re: [PATCH 04/04] resource: add new IORESOURCE_CLK type
Message-Id: <20080717162032.f5dca88d.akpm@linux-foundation.org>
In-Reply-To: <aec7e5c30807150119r160a104en5780c3288d50c60d@mail.gmail.com>
References: <20080709115428.14144.7121.sendpatchset@rx1.opensource.se>
	<20080709115502.14144.49264.sendpatchset@rx1.opensource.se>
	<20080711121813.acc71327.akpm@linux-foundation.org>
	<aec7e5c30807150119r160a104en5780c3288d50c60d@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jul 2008 17:19:24 +0900
"Magnus Damm" <magnus.damm@gmail.com> wrote:

> Hi Andrew,
> 
> Thanks for picking up my patches.
> 
> On Sat, Jul 12, 2008 at 4:18 AM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> > On Wed, 09 Jul 2008 20:55:02 +0900 Magnus Damm <magnus.damm@gmail.com> wrote:
> >
> >> This patch rearranges the values of the IORESOURCE_TYPE_BITS from
> >> one bit per type to a 4-bit counter. Also, IORESOURCE_CLK is added.
> >> Not sure if it is better to start counting from 0 instead of 1.
> >>
> >
> > I don't believe this is an adequate changelog.  It contains the "what" but
> > not the "why".
> 
> Yeah, sorry about that. I should have been more clear.
> 
> > Why did we switch from one-bit to four-bits?
> 
> The 4-bit encoding is there because I thought it was a waste of bits
> to use one bit per type. =)
> 
> I wanted to add IORESOURCE_CLK and while at it I was playing around
> with changing the code to use a 4-bit value for resource type. We may
> already have spare bits available that are more suitable for new types
> though.
> 
> > Why did we add IORESOURCE_CLK?
> 
> Currently we use struct resource with the types
> IORESOURCE_MEM/IORESOURCE_IO and IORESOUCE_IRQ to pass I/O and
> interrupt parameters to platform drivers. That works fine, but I'd
> like to extend this so we also pass clock information. Basically a
> string that tells the platform driver which clock that should be used
> with clk_get() for a certain driver instance.
> 
> I'm sure there are other ways to do this, but I'd like to have a
> generic way to pass a clock string to platform devices. Using a hard
> coded string in the device driver won't do since we may have multiple
> instances of drivers that need to use different clocks. Extending
> struct resource seems to be the easiest way to do this IMO.

umm, has there been any comment on all of this yet?

Perhaps you should just send everything again with clearer/completer
descriptions.

> If people are happy with this idea then i'd be more than happy to fix
> up and resend this patch.

We're all asleep.  Please do whatever you think is best and we'll merge
it - that'll wake 'em up.

