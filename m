Return-Path: <linux-kernel-owner+w=401wt.eu-S932473AbYDYUfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932473AbYDYUfV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 16:35:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762958AbYDYUfG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 16:35:06 -0400
Received: from wr-out-0506.google.com ([64.233.184.226]:33077 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754171AbYDYUfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 16:35:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=KnIQvKWKlOVS7pjxQWsUxdVhltm84/HS3Q9khxj+/v8FiklAW1BvRMq4uz4nswUhw6Kfu+CR94HxWe/3y0VBoLYAdJulbX5Dwv1f5GmJfgySat1OztvKSmSd6JmpFnaShHhIJFn1OKUO2gUI5eOVFSQvO+qIgGG+WDTWCVt0ato=
Message-ID: <bc64b4640804251334j7e2fbf30u358e010bc3e5d5ec@mail.gmail.com>
Date: Sat, 26 Apr 2008 00:34:55 +0400
From: Dmitry <dbaryshkov@gmail.com>
To: "Russell King" <rmk+lkml@arm.linux.org.uk>
Subject: Re: [PATCH 0/5] Clocklib: generic clocks framework
Cc: "Pavel Machek" <pavel@ucw.cz>, "Paul Walmsley" <paul@pwsan.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       "Haavard Skinnemoen" <haavard.skinnemoen@atmel.com>,
       "Paul Mundt" <lethal@linux-sh.org>,
       "pHilipp Zabel" <philipp.zabel@gmail.com>, tony@atomide.com,
       "David Brownell" <david-b@pacbell.net>, hiroshi.DOYU@nokia.com
In-Reply-To: <20080425202010.GA28893@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080420082925.GA32739@doriath.ww600.siemens.net>
	 <alpine.DEB.1.00.0804210057000.17857@utopia.booyaka.com>
	 <bc64b4640804210148p2d1c2fe0qe469152fa1a9697e@mail.gmail.com>
	 <alpine.DEB.1.00.0804250221040.14755@utopia.booyaka.com>
	 <20080425103942.GC14903@elf.ucw.cz>
	 <20080425202010.GA28893@flint.arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2008/4/26, Russell King <rmk+lkml@arm.linux.org.uk>:
> On Fri, Apr 25, 2008 at 12:39:42PM +0200, Pavel Machek wrote:
>  > WTF? There are currently around 10 copies of clock code in the tree,
>  > every one slightly different. If this can help us get rid of all that
>  > crap, that's a GOOD THING, normative or not.
>
>
> At the expense of people going off and inventing their own APIs because
>  they find that the "normatived" clock API doesn't do what they need to?

Why? We do already have the API. And it's pretty normative. And the
goal of my framework is to allow me and few other people not to
reinvent the API for non-platform clocks.

>  That's what will happen if you try to force a framework on folk which
>  they don't agree with.

If you don't want to use it, you are free to do so. E.g. you can use
your own set of functions to implement GPIO api.

-- 
With best wishes
Dmitry
