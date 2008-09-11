Return-Path: <linux-kernel-owner+w=401wt.eu-S1754839AbYIKDYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839AbYIKDYr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 23:24:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752441AbYIKDYj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 23:24:39 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47530 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752409AbYIKDYi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 23:24:38 -0400
From: Jarod Wilson <jwilson@redhat.com>
Organization: Red Hat, Inc.
To: Janne Grunau <j@jannau.net>
Subject: Re: [PATCH 08/18] lirc driver for the Soundgraph IMON IR Receivers
Date: Wed, 10 Sep 2008 23:22:22 -0400
User-Agent: KMail/1.10.1 (Linux/2.6.25.16-1.fc10.x86_64; KDE/4.1.1; x86_64; ; )
Cc: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
       Christoph Bartelmus <lirc@bartelmus.de>
References: <1220933164-10160-1-git-send-email-jwilson@redhat.com> <20080910150229.2b4f990d@bike.lwn.net> <200809102323.51289.j@jannau.net>
In-Reply-To: <200809102323.51289.j@jannau.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809102322.22538.jwilson@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 September 2008 17:23:51 Janne Grunau wrote:
> On Wednesday 10 September 2008 23:02:29 Jonathan Corbet wrote:
> > > +#define SUCCESS		0
> > > +#define	TRUE		1
> > > +#define FALSE		0
> >
> > (See my grumble in previous reviews...:)
> >
> > > +#define LOCK_CONTEXT	mutex_lock(&context->lock)
> > > +#define UNLOCK_CONTEXT	mutex_unlock(&context->lock)
> >
> > Here too.
> >
> > > +/* to prevent races between open() and disconnect() */
> > > +static DECLARE_MUTEX(disconnect_sem);
> >
> > This should be a real mutex, I think.
>
> All three already resolved. I think it would wise to stop the review of
> this patch set until we repost or review based on Jarod's git
> repository (http://git.wilsonet.com/linux-2.6-lirc.git/).

Yeah, I'd say for any driver that hasn't yet been reviewed, if anyone wants to 
continue reviewing, it might be best to poke the version in that git tree, as 
a number of issues common across multiple drivers have already (hopefully) 
been whacked. We'll definitely put together an updated patch set in the near 
future, but at the moment, we're still working through all the bits that have 
received feedback so far.

> Thanks for the reviews so far.

Indeed, very much appreciated!

-- 
Jarod Wilson
jarod@redhat.com

