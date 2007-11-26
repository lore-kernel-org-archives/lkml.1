Return-Path: <linux-kernel-owner+w=401wt.eu-S1759498AbXKZQxy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759498AbXKZQxy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 11:53:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757213AbXKZQxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 11:53:45 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:63853 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755983AbXKZQxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 11:53:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:date:to:cc:subject:message-id:in-reply-to:references:organization:x-mailer:mime-version:content-type:content-transfer-encoding:from;
        b=hlT7xwvXr2RISqxzNYZuqvS3DiAJqTOT0v4WE8cUOP6rjIAt2f8d9NPkekgqpaCudi5NTlKobK6LNV/s0YfecbtvH1mhF8ZrL33BxcWXDZjvFQX54CEDupjX2CVNQInMCruwuAxmT1qbpKe/0P+ks9pW0WvcfTILfbtc3vFBmwI=
Date: Mon, 26 Nov 2007 17:53:39 +0100
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Cc: "Paul Mundt" <lethal@linux-sh.org>,
       "Kristoffer Ericson" <kristoffer.ericson@gmail.com>,
       "Russell King" <linux@arm.linux.org.uk>,
       linux-main <linux-kernel@vger.kernel.org>
Subject: Re: Question regarding naming scheme (HP Jornada 6XX/7XX)
Message-Id: <20071126175339.5e8fa5b4.Kristoffer.ericson@gmail.com>
In-Reply-To: <d120d5000711260640y68c6136fy181b63af85bf6ae6@mail.gmail.com>
References: <20071126000329.8e7304c5.Kristoffer.ericson@gmail.com>
	<20071126043030.GA25664@linux-sh.org>
	<d120d5000711260640y68c6136fy181b63af85bf6ae6@mail.gmail.com>
Organization: JLime
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Nov 2007 09:40:14 -0500
"Dmitry Torokhov" <dmitry.torokhov@gmail.com> wrote:

> On Nov 25, 2007 11:30 PM, Paul Mundt <lethal@linux-sh.org> wrote:
> > On Mon, Nov 26, 2007 at 12:03:29AM +0100, Kristoffer Ericson wrote:
> >
> > > Why I want to use 600-series/700-series instead of 6XX/7XX is simply
> > > because 600-series/700-series leaves no doubt.
> > >
> > Apparently your end users are more technically apt than I am, as I have
> > no idea how using 00 over XX makes things any less ambiguous.
> >
> > We already have a 6xx mach-type that drivers can set their dependency on.
> > If it's not 680-only, then that's a perfectly reasonable dependency. Feel
> > free to change the Kconfig text to make the description more useful, but
> > please don't start idly shuffling around code and symbols because users
> > can't work out why a driver is available that they can't support.
> 
> Agreed. Users simply should not care what a particular module is
> called. If Kconfig entries and/or its help is unclear on whta devices
> are supported by the drivers let's fix that.
> 
Ok, guess the idea was shot down then :). I'll look at Kconfigs to see how I can make it clearer.
thx for feedback.

> -- 
> Dmitry
