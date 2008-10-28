Return-Path: <linux-kernel-owner+w=401wt.eu-S1753430AbYJ1BCe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430AbYJ1BCe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 21:02:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751867AbYJ1BCY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 21:02:24 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:53648 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752112AbYJ1BCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 21:02:24 -0400
X-Sasl-enc: 5cG+CaJb+Vbeu9rVuqY2m1IORL0FuaGTj2vijCMZz55J 1225155741
Subject: Re: [PATCH 2/6] autofs4 - remove string terminator check
From: Ian Kent <raven@themaw.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       autofs@linux.kernel.org
In-Reply-To: <1225153622.2938.1.camel@zeus.themaw.net>
References: <20081023023513.4508.54940.stgit@raven.themaw.net>
	 <20081023023522.4508.27987.stgit@raven.themaw.net>
	 <20081027133131.f2011d28.akpm@linux-foundation.org>
	 <1225153622.2938.1.camel@zeus.themaw.net>
Content-Type: text/plain
Date: Tue, 28 Oct 2008 10:02:17 +0900
Message-Id: <1225155737.2938.17.camel@zeus.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This response is a bit confusing, let me try to fix that.

On Tue, 2008-10-28 at 09:27 +0900, Ian Kent wrote:
> On Mon, 2008-10-27 at 13:31 -0700, Andrew Morton wrote:
> > On Thu, 23 Oct 2008 10:35:22 +0800
> > Ian Kent <raven@themaw.net> wrote:
> > 
> > > Remove unnecessary string terminator check.
> > 
> > Why is it unnecessary?
> > 
> > Does this change alter behaviour in any way?
> > 
> > Does it fix a bug?
> 
> Umm .... it was done in response to your comment, quoted below ...
> 
<quote>
> > +/*
> > + * Check a string doesn't overrun the chunk of
> > + * memory we copied from user land.
> > + */
> > +static int invalid_str(char *str, void *end)
> > +{
> > +     while ((void *) str <= end)
> > +             if (!*str++)
> > +                     return 0;
> > +     return -EINVAL;
> > +}
> 
> What is this?  We copy strings in from userspace in 10000 different
> places without needing checks such as this?
</quote>


