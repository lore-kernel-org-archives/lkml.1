Return-Path: <linux-kernel-owner+w=401wt.eu-S1758060AbXJaKPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758060AbXJaKPi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 06:15:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753641AbXJaKP3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 06:15:29 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60089 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753580AbXJaKP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 06:15:28 -0400
Date: Wed, 31 Oct 2007 03:14:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pierre Peiffer <pierre.peiffer@bull.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.23-mm1] Change the ida/idr_pre_get() return value to
 follow the kernel convention
Message-Id: <20071031031453.ae873860.akpm@linux-foundation.org>
In-Reply-To: <472853A8.8040308@bull.net>
References: <20071030171350.cd25b87c.pierre.peiffer@bull.net>
	<20071030103356.bf11d1a7.akpm@linux-foundation.org>
	<472853A8.8040308@bull.net>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Oct 2007 11:06:32 +0100 Pierre Peiffer <pierre.peiffer@bull.net> wrote:

> > 
> > Storage classes which need to allcoate memory at insertion time are hard:
> > radix_tree_preload() gets it right in terms of robustness, but it's an
> > awful lot of fuss.
> > 
> > IDR gets it all wrong and compounds the problem by implementing internal
> > locking.  It shouldn't have done that: storage code like this should use
> > only caller-provided locking.
> 
> Ok, but for that, I prefer to let the IDR maintainers see what they can do,
> because I'm not familiar at all with the IDR implementation and can not focus on
> that now.

Jim isn't very active nowadays

> So do you think that just providing a new API (something like
> idr_pre_allocate(), as you say above) would be better than nothing ?
> Or we just leave the code as is for now ?

I guess we can leave it as-is if the present interface isn't actually
causing you guys any problems.
