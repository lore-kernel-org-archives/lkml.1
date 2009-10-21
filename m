Return-Path: <linux-kernel-owner+w=401wt.eu-S1753080AbZJUARu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080AbZJUARu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 20:17:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752525AbZJUARt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 20:17:49 -0400
Received: from ozlabs.org ([203.10.76.45]:59243 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751069AbZJUARt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 20:17:49 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 2/4] kmemleak: Scan the _ftrace_events section in modules
Date: Wed, 21 Oct 2009 10:47:49 +1030
User-Agent: KMail/1.11.2 (Linux/2.6.28-15-generic; KDE/4.2.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, Zdenek Kabelac <zdenek.kabelac@gmail.com>
References: <20091019144602.14221.27128.stgit@pc1117.cambridge.arm.com> <200910201124.18695.rusty@rustcorp.com.au> <tnx7huqa287.fsf@pc1117.cambridge.arm.com>
In-Reply-To: <tnx7huqa287.fsf@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910211047.50608.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Oct 2009 07:09:20 pm Catalin Marinas wrote:
> Rusty Russell <rusty@rustcorp.com.au> wrote:
> > On Tue, 20 Oct 2009 01:19:29 am Catalin Marinas wrote:
> >> This section contains pointers to allocated objects and not scanning it
> >> leads to false positives.
> >
> > Thanks, applied.  Want me to push this for 2.6.32?
> 
> This patch requires 1/4 to be applied as it changes the kmemleak API a
> bit, so it won't even compile on its own. I can push them both
> together with your ack for the second.
> 
> I'm not sure whether API changes make sense during -rc releases, I was
> more thinking of pushing the patches for 2.6.33.

Definitely 2.6.33 material.  And if it's tied to your other patches, best
for you to hold them all.

Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Thanks,
Rusty.
