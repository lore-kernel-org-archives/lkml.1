Return-Path: <linux-kernel-owner+w=401wt.eu-S1755249AbYIJVYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249AbYIJVYQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 17:24:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752765AbYIJVYB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 17:24:01 -0400
Received: from scing.com ([217.160.110.58]:47048 "EHLO scing.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752730AbYIJVYA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 17:24:00 -0400
X-GoodMailTo: skipped
X-GoodMailTo: skipped
X-GoodMailTo: skipped
X-GoodMailTo: skipped
From: Janne Grunau <j@jannau.net>
To: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH 08/18] lirc driver for the Soundgraph IMON IR Receivers
Date: Wed, 10 Sep 2008 23:23:51 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Jarod Wilson <jwilson@redhat.com>,
       Christoph Bartelmus <lirc@bartelmus.de>
References: <1220933164-10160-1-git-send-email-jwilson@redhat.com> <1220933164-10160-9-git-send-email-jwilson@redhat.com> <20080910150229.2b4f990d@bike.lwn.net>
In-Reply-To: <20080910150229.2b4f990d@bike.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809102323.51289.j@jannau.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 September 2008 23:02:29 Jonathan Corbet wrote:
> > +#define SUCCESS		0
> > +#define	TRUE		1
> > +#define FALSE		0
>
> (See my grumble in previous reviews...:)
>
> > +#define LOCK_CONTEXT	mutex_lock(&context->lock)
> > +#define UNLOCK_CONTEXT	mutex_unlock(&context->lock)
>
> Here too.
>
> > +/* to prevent races between open() and disconnect() */
> > +static DECLARE_MUTEX(disconnect_sem);
>
> This should be a real mutex, I think.

All three already resolved. I think it would wise to stop the review of 
this patch set until we repost or review based on Jarod's git 
repository (http://git.wilsonet.com/linux-2.6-lirc.git/).

Thanks for the reviews so far.

Janne
