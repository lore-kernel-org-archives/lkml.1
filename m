Return-Path: <linux-kernel-owner+w=401wt.eu-S932125AbXJ0AY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932125AbXJ0AY1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 20:24:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753101AbXJ0AYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 20:24:21 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:59521 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752586AbXJ0AYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 20:24:20 -0400
Date: Sat, 27 Oct 2007 02:24:49 +0200
From: Adrian Bunk <bunk@kernel.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Kir Kolyshkin <kir@swsoft.com>, containers@lists.osdl.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, kir@openvz.org
Subject: Re: [Devel] [PATCH] pidns: Place under CONFIG_EXPERIMENTAL (take 2)
Message-ID: <20071027002448.GH30533@stusta.de>
References: <CBC546DD07068244AEC110EFEDA58B7235893F@excite.int.sw-soft.com> <m1ve8ty1tq.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <m1ve8ty1tq.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2007 at 03:59:29PM -0600, Eric W. Biederman wrote:
> "Kir Kolyshkin" <kir@swsoft.com> writes:
> 
> > Eric,
> >
> > Could you please hold off the horses a bit and wait till Pavel Emelyanov
> > returns? It means next Monday; he's currently at a conference whose organisers
> > don't provide internet access.
> 
> When we decided to go top down (i.e. user interface first) instead of
> bottom up with the pid namespace implementation it was my
> understanding that we had agreed we would make the pid namespaces
> depend on CONFIG_EXPERIMENTAL so that we wouldn't be stuck forever
> supporting early ABI mistakes.
>...

CONFIG_EXPERIMENTAL is a weak hint that some code might not (yet) be in 
a perfect state, but it does not have any semantics regarding
userspace ABIs.

A dependency on BROKEN seems more appropriate.

> Eric

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

