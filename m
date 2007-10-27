Return-Path: <linux-kernel-owner+w=401wt.eu-S1754185AbXJ0CTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185AbXJ0CTR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 22:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751322AbXJ0CTE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 22:19:04 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59006 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752205AbXJ0CTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 22:19:03 -0400
Date: Fri, 26 Oct 2007 19:18:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: ebiederm@xmission.com, kir@swsoft.com, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       kir@openvz.org
Subject: Re: [Devel] [PATCH] pidns: Place under CONFIG_EXPERIMENTAL (take 2)
Message-Id: <20071026191845.fd0f75c8.akpm@linux-foundation.org>
In-Reply-To: <20071027020408.GO30533@stusta.de>
References: <CBC546DD07068244AEC110EFEDA58B7235893F@excite.int.sw-soft.com>
	<m1ve8ty1tq.fsf@ebiederm.dsl.xmission.com>
	<20071027002448.GH30533@stusta.de>
	<m18x5puyw7.fsf@ebiederm.dsl.xmission.com>
	<20071027020408.GO30533@stusta.de>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sat, 27 Oct 2007 04:04:08 +0200 Adrian Bunk <bunk@kernel.org> wrote:
> > be happy to hear if someone has a better idea.
> 
> There is a difference between "complete the feature" and "early adopters 
> to start playing with the feature" on the one side, and making something 
> available in a released kernel on the other side.
> 
> For development and playing with it it can depend on BROKEN (perhaps 
> with the dependency removed through the first -rc kernels), but as soon 
> as it's available in a -final kernel the ABI is fixed.
> 

Yes, if we're not 100% certain that the interfaces are correnct and unchanging
and that the implementation is solid, we should disable the feature at Kconfig time.

The best option would be to fix things asap.  But assuming that option isn't
reasonable and/or safe, we can slip a `depends on BROKEN' into -rc6 then
resume development for 2.6.25.

