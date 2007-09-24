Return-Path: <linux-kernel-owner+w=401wt.eu-S1758067AbXIXKzr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758067AbXIXKzr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 06:55:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752767AbXIXKzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 06:55:40 -0400
Received: from rv-out-0910.google.com ([209.85.198.189]:12765 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409AbXIXKzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 06:55:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kYIX6OL1IR5CKjLLMU+d5v0RERR+RaRKNQ9jz/crelWlrZR4BL3wP79XmEzTX4LsrRVBNnbR5F9+20Jmm31C4WQZM74Tipl+39sRRe+UU8sVU/ivy88qpZvpOXpAWbn1JRTBO1PazFskgBqs6k+Ja8cmPA2UJQh+Ji6Zeq9Rh40=
Message-ID: <3f9a31f40709240355t52e536a2u833fea747f074382@mail.gmail.com>
Date: Mon, 24 Sep 2007 16:25:38 +0530
From: "Jaswinder Singh" <jaswinderlinux@gmail.com>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Subject: Re: 2.6.22.7 autoconf.h is screwed up
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0709240647140.1295@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3f9a31f40709240320mb213a7an87cee8bf5517d7f7@mail.gmail.com>
	 <Pine.LNX.4.64.0709240625140.31104@localhost.localdomain>
	 <3f9a31f40709240335w441699b5y366211baeebde871@mail.gmail.com>
	 <Pine.LNX.4.64.0709240637140.791@localhost.localdomain>
	 <3f9a31f40709240346o21eb48b8u518a1af72faa9e8f@mail.gmail.com>
	 <Pine.LNX.4.64.0709240647140.1295@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

hello rday,

On 9/24/07, Robert P. J. Day <rpjday@mindspring.com> wrote:
> On Mon, 24 Sep 2007, Jaswinder Singh wrote:
>
> > hello rday,
> >
> > On 9/24/07, Robert P. J. Day <rpjday@mindspring.com> wrote:
> > > On Mon, 24 Sep 2007, Jaswinder Singh wrote:
> > >
> > > > hello rday,
> > > >
> > > > In my view autoconf.h is the index of kernel you are using. By
> > > > reading autoconf.h you will know what Architecture, drivers is
> > > > selected.
> > > >
> > > > For example, If we are using some ARM based board, If you give me
> > > > your autoconf.h , I can replicate same environment as yours. If it
> > > > is not properly formatted it is very difficult to read and come to
> > > > some conclusion.
> > >
> > > no, the proper thing to do is give someone your .config file if you
> > > want them to reproduce your configuration, and leave autoconf.h out of
> > > it.
> > >
> >
> > yes, you are right. So autoconf.h is obsolete and replaced by .config
> > . And now autoconf.h looks so funny and scary that no body dares to
> > open autoconf.h in future ;-)
>
> no, you're missing the point.  the .config file represents your
> selection of kernel options, it's what you can hand to someone if they
> want to reproduce your configuration.  autoconf.h, on the other hand,
> is automatically generated from your .config file once you start the
> build process.  it is in no way "obsolete", it's used by the build
> process -- it's just not meant to be manipulated by users.
>
> don't worry about autoconf.h, just leave it alone -- the build process
> takes care of it.
>

So it is obsolete for user's point of view, right ?

That's why it is written in such a way that no human can read it (Not
human readable). right ?

Thank you,

Jaswinder Singh.
