Return-Path: <linux-kernel-owner+w=401wt.eu-S1763055AbZDBWvB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763055AbZDBWvB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 18:51:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755363AbZDBWux
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 18:50:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35151 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752337AbZDBWuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 18:50:52 -0400
Date: Thu, 2 Apr 2009 15:44:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, niv@us.ibm.com,
       dvhltc@us.ibm.com, dhowells@redhat.com, lethal@linux-sh.org,
       kernel@wantstofly.org, matthew@wil.cx
Subject: Re: [PATCH] v3 RCU: the bloatwatch edition
Message-Id: <20090402154444.b143efcf.akpm@linux-foundation.org>
In-Reply-To: <20090402223605.GB19007@elte.hu>
References: <20090203183426.GA14409@linux.vnet.ibm.com>
	<20090329203118.GA14005@linux.vnet.ibm.com>
	<20090402223605.GB19007@elte.hu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Apr 2009 00:36:05 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> Andrew, what do you think?

I'm really struggling to see how the 900-odd bytes saved justifies
creating (yet another) variant of core kernel machinery.

> A worry is yet another RCU variant - we already have 3.

That would make four?

I wonder if that was sane of us.

> A trick we could use would be to put it into Documentation/rcu/, 
> linked in via some clever Makefile magic and only usable if a 
> ultra-embedded developer does a build with something like 
> CONFIG_RCU_TINY=y. That way there's no real maintenance and testing 
> overhead.
> 
> It _does_ have documentation value beyond the ~900 bytes: it's the 
> simplest and smallest possible still-working UP RCU implementation 
> so it would be easy to teach RCU concepts via that, gradually.
> 

hm.
