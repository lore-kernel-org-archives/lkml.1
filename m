Return-Path: <linux-kernel-owner+w=401wt.eu-S1753968AbYJ1LRk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968AbYJ1LRk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 07:17:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752301AbYJ1LR3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 07:17:29 -0400
Received: from relay1.sgi.com ([192.48.171.29]:39862 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751939AbYJ1LR3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 07:17:29 -0400
Date: Tue, 28 Oct 2008 06:17:27 -0500
From: Dean Nelson <dcn@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sgi-xp: only build for ia64-sn2 when CONFIG_IA64_GENERIC specified v.2
Message-ID: <20081028111727.GA32073@sgi.com>
References: <20081023183335.GA24139@sgi.com> <20081027150256.8fb5bc19.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081027150256.8fb5bc19.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2008 at 03:02:56PM -0700, Andrew Morton wrote:
> On Thu, 23 Oct 2008 13:33:35 -0500
> Dean Nelson <dcn@sgi.com> wrote:
> 
> > For the time being build for ia64-sn2 alone when CONFIG_IA64_GENERIC is
> > specified.
> > 
> 
> It is 100% unclear (to me) why this change is being made.

It eliminates a dependency of the XP/XPC drivers on having the GRU driver
insmod'd in order to insmod them, when running on an ia64-sn2 system.

On such a system the GRU driver serves no useful purpose.

> 
> Apparently this is considered a needed-in-2.6.28 change.  But I don't
> know why.
> 
> If I knew that then I'd be in a better position to work out whether it
> is also needed in 2.6.27.x, to which it also applies cleanly.

Having it applied to 2.6.27.x would be a good thing.

> IOW: better changelogs, please.

Sorry.

