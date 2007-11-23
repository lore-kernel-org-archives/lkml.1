Return-Path: <linux-kernel-owner+w=401wt.eu-S1757089AbXKWMkI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757089AbXKWMkI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 07:40:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755801AbXKWMj5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 07:39:57 -0500
Received: from py-out-1112.google.com ([64.233.166.183]:9157 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755578AbXKWMj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 07:39:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LqE7G6S5PuLo6wxhVXO6H74z7fjLFvF06vw2EgXOzIu1HccSrajmswzxfHQkwOC+oEg/P+jzvJfDGzvhkighaSSpc8+amsKa2EOuqeQnxRZijij5783Iy5HkIlbEaw4WqdVgMXuoNzIUODMEYRX0xVBjaQOJX82cyYPNVShMQ2g=
Message-ID: <cfd18e0f0711230439m1d72abdle4d5050b0bd935a1@mail.gmail.com>
Date: Fri, 23 Nov 2007 13:39:55 +0100
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: Where is the new timerfd?
Cc: "Davide Libenzi" <davidel@xmailserver.org>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20071122173437.e74890a8.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <cfd18e0f0711220324l533d9048yf05c399019764b62@mail.gmail.com>
	 <Pine.LNX.4.64.0711220933330.7256@alien.or.mcafeemobile.com>
	 <cfd18e0f0711221048k538d05abk8e4303d5f90a6e1b@mail.gmail.com>
	 <Pine.LNX.4.64.0711221145410.7431@alien.or.mcafeemobile.com>
	 <20071122162430.48f55995.akpm@linux-foundation.org>
	 <Pine.LNX.4.64.0711221634510.7431@alien.or.mcafeemobile.com>
	 <20071122173437.e74890a8.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Thu, 22 Nov 2007 16:35:38 -0800 (PST) Davide Libenzi
> <davidel@xmailserver.org> wrote:
>
> > On Thu, 22 Nov 2007, Andrew Morton wrote:
[...]
> > > Last I recall, we removed the API for 2.6.23 because we intended to do a
> > > different interface for 2.6.24.
> > >
> > > But I don't recall seeing any timerfd patches in maybe a month.
> >
> > Was sent on Sep 23, Subject: new timerfd API
>
> Half of us weren't born then ;)
>
> > Do you want me to repost?
>
> yes please.

I suppose this means that timerfd will only go in for 2.6.25.  I don't
have a problem with that, but we better make sure that the existing
timerfd in 2.6.24 is still disabled.  (Andrew had a one liner for
that, but I haven't checked if it's in place.)

Cheers,

Michael
