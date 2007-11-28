Return-Path: <linux-kernel-owner+w=401wt.eu-S1761473AbXK1X7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761473AbXK1X7Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 18:59:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758280AbXK1X7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 18:59:13 -0500
Received: from mx1.redhat.com ([66.187.233.31]:34511 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758116AbXK1X7L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 18:59:11 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: David Wilder <dwilder@us.ibm.com>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 20/27] ptrace: arch_has_block_step
In-Reply-To: David Wilder's message of  Wednesday, 28 November 2007 15:39:55 -0800 <474DFC4B.5060006@us.ibm.com>
References: <20071125215507.4B89226F8C5@magilla.localdomain>
	<20071125220552.C8D5126F8C5@magilla.localdomain>
	<474DFC4B.5060006@us.ibm.com>
X-Shopping-List: (1) Impotent socks
   (2) Clairvoyant mountains
   (3) Infectious socks
   (4) Big bacon
Message-Id: <20071128235834.A34AB26F8E7@magilla.localdomain>
Date: Wed, 28 Nov 2007 15:58:34 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Roland McGrath wrote:
> <snip>
> > 
> > +#ifndef arch_has_block_step
> > +/**
> > + * arch_has_block_step - does this CPU support user-mode block-step?
> > + *
> > + * If this is defined, then there must be a function declaration or inline
> > + * for user_enable_block_step(), and arch_has_single_step() must be defined
> > + * too.  arch_has_block_step() should evaluate to nonzero iff the machine
> > + * supports step-until-branch for user mode.  It can be a constant or it
> > + * can test a CPU feature bit.
> > + */
> > +#define arch_has_single_step()		(0)
> 
> should this be #define arch_has_block_step()		(0)

Oops, yes it should.


Thanks,
Roland
