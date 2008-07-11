Return-Path: <linux-kernel-owner+w=401wt.eu-S1759863AbYGKWm7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759863AbYGKWm7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 18:42:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751976AbYGKWmw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 18:42:52 -0400
Received: from mail.queued.net ([207.210.101.209]:2053 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125AbYGKWmw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 18:42:52 -0400
Date: Fri, 11 Jul 2008 18:42:22 -0400
From: Andres Salomon <dilinger@queued.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Cortland Setlow <csetlow@tower-research.com>,
       corbet@lwn.net, video4linux-list@redhat.com,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH resend] ov7670: clean up ov7670_read semantics
Message-ID: <20080711184222.5403dca9@fred>
In-Reply-To: <20080711151919.9cda44ea.akpm@linux-foundation.org>
References: <20080711165216.4dc32c4c@fred>
	<20080711151919.9cda44ea.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jul 2008 15:19:19 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 11 Jul 2008 16:52:16 -0400 Andres Salomon
> <dilinger@queued.net> wrote:
> 
> > [note: this should probably go in for 2.6.26, as it fixes a bug in
> > ov7670_s_fmt where we incorrectly think that we've failed because we
> > return !0]
> > 
> 
> In which case 2.6.25.x wants the fix as well?
> 

Yep!

[...]
> > diff --git a/drivers/media/video/ov7670.c
> > b/drivers/media/video/ov7670.c index 2bc6bdc..d7bfd30 100644
> > --- a/drivers/media/video/ov7670.c
> > +++ b/drivers/media/video/ov7670.c
> > @@ -406,8 +406,10 @@ static int ov7670_read(struct i2c_client *c,
> > unsigned char reg, int ret;
> 
> You have some wordwrapping happening there.
> 

Eek, thanks.  The original send wasn't line-wrapped, I'm not sure how
that happened.

