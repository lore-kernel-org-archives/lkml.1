Return-Path: <linux-kernel-owner+w=401wt.eu-S1754864AbXEJBam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864AbXEJBam (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 21:30:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751003AbXEJBaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 21:30:35 -0400
Received: from ozlabs.org ([203.10.76.45]:57356 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1749667AbXEJBae (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 21:30:34 -0400
Subject: Re: lguest re-review
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
       "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
In-Reply-To: <20070509175018.a4a685b8.akpm@linux-foundation.org>
References: <20070509025122.f3cb7247.akpm@linux-foundation.org>
	 <1178756648.7286.182.camel@localhost.localdomain>
	 <20070509175018.a4a685b8.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 10 May 2007 11:30:32 +1000
Message-Id: <1178760632.7286.187.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-09 at 17:50 -0700, Andrew Morton wrote:
> On Thu, 10 May 2007 10:24:08 +1000
> Rusty Russell <rusty@rustcorp.com.au> wrote:
> 
> > On Wed, 2007-05-09 at 02:51 -0700, Andrew Morton wrote:
> > > Some concern was expressed over the lguest review status, so I shall send
> > > the patches out again for people to review, to test, to make observations
> > > about the author's personal appearance, etc.
> > 
> > Thanks Andrew,
> > 
> > 	This means I can finally ack this patch (thanks Eric):
> > 
> > From: ebiederm@xmission.com (Eric W. Biederman)
> > Subject: [PATCH] Revert "[PATCH] paravirt: Add startup infrastructure for paravirtualization"
> > 
> > This reverts commit c9ccf30d77f04064fe5436027ab9d2230c7cdd94.
> 
> I don't get it.  Does lguest no longer need this code, or will
> it be reintroduced with an lguest merge, or something else?

Lguest no longer needs it (the magic signature patch you took).

HPA and Eric are brewing a new, shinier way for booting not-a-normal-pc
which will address lguest as well as others.  But it seems they first
need to go through the "who knows most about ancient PCs" slapfight.

Thanks!
Rusty.

