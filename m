Return-Path: <linux-kernel-owner+w=401wt.eu-S1757952AbZDPQMn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757952AbZDPQMn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 12:12:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756170AbZDPQMF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 12:12:05 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:36367 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755378AbZDPQMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 12:12:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=b15s9JEkvt9uMSKGxJl6ytUMOSKgHM4ShV1aQ3jFVO42gd/FjC/2SP02KPFwAj/bbZ
         NPnNZVnyTL8RHLv2wHOpwXTx5opp38lca5PUqP09wxXEI2rl0RUrWpmRN9IgbxZpb9b2
         8gCgJch3o/YkU05Wdcg+C+LszCdNq1jXxzVGQ=
Date: Thu, 16 Apr 2009 20:12:15 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Greg Kurz <gkurz@fr.ibm.com>
Cc: Oren Laadan <orenl@cs.columbia.edu>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>, containers@lists.osdl.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: C/R without "leaks" (was: Re: Creating tasks on restart:
	userspace vs kernel)
Message-ID: <20090416161215.GA8505@x200.localdomain>
References: <49E40662.2040508@cs.columbia.edu> <20090414163633.GE27461@x200.localdomain> <49E4D89D.9060903@cs.columbia.edu> <20090415195629.GD26994@x200.localdomain> <1239835337.6610.6.camel@bahia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239835337.6610.6.camel@bahia>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 16, 2009 at 12:42:17AM +0200, Greg Kurz wrote:
> On Wed, 2009-04-15 at 23:56 +0400, Alexey Dobriyan wrote:

> > There are sockets and live netns as the most complex example. I'm not
> > prepared to describe it exactly, but people wishing to do C/R with
> > "leaks" should be very careful with their wishes.
> 
> They should close their sockets before checkpoint and find/have some way
> to reconnect after. This implies some kind of C/R awareness in the code
> to be checkpointed.

How do you imagine sshd closing sockets and reconnecting?
