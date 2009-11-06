Return-Path: <linux-kernel-owner+w=401wt.eu-S1753295AbZKFGa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295AbZKFGa2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 01:30:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752580AbZKFGa0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 01:30:26 -0500
Received: from ozlabs.org ([203.10.76.45]:48167 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752309AbZKFGa0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 01:30:26 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] BUILD_BUG_ON: make it handle more cases
Date: Fri, 6 Nov 2009 17:00:26 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; i686; ; )
Cc: Hollis Blanchard <hollisb@us.ibm.com>, Jan Beulich <JBeulich@novell.com>,
       akpm@linux-foundation.org, linuxppc-dev@lists.ozlabs.org,
       kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org
References: <4AC1E15502000078000516B5@vpn.id2.novell.com> <200911051658.36265.rusty@rustcorp.com.au> <20091105173842.c94ba501.sfr@canb.auug.org.au>
In-Reply-To: <20091105173842.c94ba501.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200911061700.27493.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Nov 2009 05:08:42 pm Stephen Rothwell wrote:
> Hi Rusty,
> 
> On Thu, 5 Nov 2009 16:58:36 +1030 Rusty Russell <rusty@rustcorp.com.au> wrote:
> >
> > Huh?  virtio_has_feature does:
> > 
> > 	if (__builtin_constant_p(fbit))
> > 		BUILD_BUG_ON(fbit >= 32);
> > 	else
> > 		BUG_ON(fbit >= 32);
> 
> In Linus' tree (and linux-next) it looks like this:

Ah.  My patch series fixes that as part of removing MAYBE_BUILD_BUG_ON.

I've put both in for linux-next.

Cheers,
Rusty.
