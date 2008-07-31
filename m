Return-Path: <linux-kernel-owner+w=401wt.eu-S1756430AbYGaVOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756430AbYGaVOV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 17:14:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752666AbYGaVOM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 17:14:12 -0400
Received: from 1wt.eu ([62.212.114.60]:2308 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751223AbYGaVOK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 17:14:10 -0400
Date: Thu, 31 Jul 2008 23:14:06 +0200
From: Willy Tarreau <w@1wt.eu>
To: Richard Hartmann <richih.mailinglist@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: iptables, NAT, DNS & Dan Kaminsky
Message-ID: <20080731211406.GA19104@1wt.eu>
References: <2d460de70807300753w33c43340xaa52c54add501306@mail.gmail.com> <20080730195548.GA615@1wt.eu> <2d460de70807310759s2a7d6c4k5ba7e0e6a5bd9cf6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2d460de70807310759s2a7d6c4k5ba7e0e6a5bd9cf6@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

On Thu, Jul 31, 2008 at 04:59:24PM +0200, Richard Hartmann wrote:
> On Wed, Jul 30, 2008 at 21:55, Willy Tarreau <w@1wt.eu> wrote:
> 
> > you should re-post your question to relevant lists. I think that
> > the netfilter ML would be more appropriate. The list you posted to
> > is about Linux kernel development, which has nothing to do with
> > how to setup iptables rules, so I don't think you'll find useful
> > answers here, if any.
> 
> I also asked said list, but as I am especially concerned about
> what kernels versions act in which way, I thought I would try
> my luck here, as well.

Then you should wait a bit, there may be a lot of people in holidays.

> > And BTW I don't think that many of the people
> > reading LKML care a dime about the "exploit" for poorly configured
> > DNS servers.
> 
> It is an exploit that is being abused as we speak and,

That does not mean that abused servers were properly set up.

> unless you
> mean source address filtering or the like, has nothing to do with
> how the servers are configured

Yes it has. I don't want to enter a DNS debate and I'm not even qualified
for that. But I can't find any reason why you would let your servers offer
public resolving service for outsiders. They must resolve hosted zones for
outsiders, hosted+outside zones for insiders and that's all. So that *should*
be either a non-issue, or a valid reason to fix the issue.

Regards,
Willy

