Return-Path: <linux-kernel-owner+w=401wt.eu-S932414AbXH2HmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932414AbXH2HmQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 03:42:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753795AbXH2HmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 03:42:05 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:24307 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197AbXH2HmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 03:42:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=sD/r7tF5RSTnPgKH8byBMyVL3kMteOsXQ0Fb5cpCB81WbLClkPsMpmHgSkJ0vs6YqIDLap4dHn5wrxGgcUM/E3idA7gMD61tuEXEfXTrLyBAyWTUUX1JJ11GypCepgiWRcJWS1rHjRZmn/klpRQ2wBTMj4NqXGN70YknjzDC0ig=
Message-ID: <32209efe0708290042g362fbfadj38fe57e0de7f3af@mail.gmail.com>
Date: Wed, 29 Aug 2007 00:42:02 -0700
From: "Natalie Protasevich" <protasnb@gmail.com>
To: "David Rees" <drees76@gmail.com>
Subject: Re: Who wants to maintain KR list for stable releases? (was Re: nmi_watchdog=2 regression in 2.6.21)
Cc: "Daniel Walker" <dwalker@mvista.com>,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "=?ISO-8859-1?Q?Bj=F6rn_Steinbrink?=" <B.Steinbrink@gmx.de>,
       eranian@hpl.hp.com, ak@suse.de, linux-kernel@vger.kernel.org
In-Reply-To: <72dbd3150708271212w6bcca4c4web26d7cb25892afc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1186531609.22044.50.camel@imap.mvista.com>
	 <46CDE94A.7000600@googlemail.com>
	 <1187904169.2435.83.camel@dhcp193.mvista.com>
	 <46D21E8E.4000003@googlemail.com>
	 <20070827005131.b93f5935.akpm@linux-foundation.org>
	 <6bffcb0e0708270438j4c92a0b4m1396b4010f25bfb5@mail.gmail.com>
	 <1188227585.2435.192.camel@dhcp193.mvista.com>
	 <6bffcb0e0708270826p7a7fb044re53d0db4094bc3d5@mail.gmail.com>
	 <1188229197.2435.207.camel@dhcp193.mvista.com>
	 <72dbd3150708271212w6bcca4c4web26d7cb25892afc@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

n 8/27/07, David Rees <drees76@gmail.com> wrote:
> On 8/27/07, Daniel Walker <dwalker@mvista.com> wrote:
> > Now that I'm looking at the kernel bugzilla .. If you set the kernel
> > version to 2.6.22 and set the "Regression" check box you could denote
> > the fact that it's a regression in that kernel version ..
> >
> > I don't know if this URL is going to come out right,
> >
> > <snip url>
> >
> > That should be open bugs , kernel version 2.6.22, with the regression
> > check box set ..
> >
> > So you may not need a master tracking bug ..
>
> Yep, that's another way to do it. The method I described earlier is
> commonly used when you don't have the handy regression field in
> bugzilla. The technique is handy for creating lists for tracking other
> types of issues which don't necessarily fall into a component and you
> don't want to bother customizing bugzilla.
>
> I also suspect that there will be a number of common searches that
> many people will find useful. With recent versions of bugzilla (3.0+)
> you can share searches within groups, but it may be helpful to have a
> wiki or some other page where useful searches can be stored, or one of
> the templates edited to include those common searches.
>
> -Dave
>

What David suggested - is exactly what I was going to do, checking out
3.0 etc. Pretty much every post from everyone in this thread is an
action item.

I think we should start getting unsolved regressions in bugzilla, as a
"natural process". And maybe throwing them all in there even those
that got immediately resolved is probably a good thing - better than
to miss one. Either you do it Michal or dump it on me (I'm still doing
sorting out and cleaning things up, actually myself and Adrian - are
re-basing everything and getting rid of stale stuff).
Then I think bugzilla needs:
     adding more categories such as security, system calls (lots of
implementation suggestions for posix and non-posix ones), locking,
etc;
     improved searches - for sure, for example in addition to
pre-cooked queries make possible using "raw" queries directly on sql,
which will address misplaced bugs and will make categories more
dynamic;
    recipe database, for standard debugging requests and procedures
(serial console, getting sysreq traces, bisecting etc. - things to cut
and paste)
    user modifiable personal environment ("my bugzilla"), more of
morph type interface around the database.
... not mentioning all flaws and problems with current one (cannot get
back to home page, clear previous search, do certain updates in one
step and so on)

Regressions need to be tracked in effective manner, and I also noticed
counter intuitive question that we have now (the infamous "last
release when it _didn't_ happen") is clearly not the way to go, rather
 adding simple boxes "Was working in XX" and "Not working in XX" or
similar straightforward question.

In my opinion bugzilla is far from being a convenient tool. I suspect
that hating bugzilla comes down to having to deal with no
sophisticated interface that is inadequate - when so many nice and
slick tools and sites are around that we all used to.  I am also
investigating and checking out other bugzillas looking for good ideas.

Thanks,
--Natalie
