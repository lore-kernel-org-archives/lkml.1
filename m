Return-Path: <linux-kernel-owner+w=401wt.eu-S1761522AbXETBES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761522AbXETBES (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 21:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756529AbXETBEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 21:04:08 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:29478 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755763AbXETBEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 21:04:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=k+AXwGmd5MuFuWX6w0o18gp1SaNe4U/fvfbn14REx9tu25mQg1DSJBVdDA9tlMFqC0DSI9DR/fBLRrnWzqbGk+OcUpnDzFcOZiHgob6o5/Z0ZwPnd9IziI+imXUaa15Qmbbp6oN0GMJgbgVSX85F0ykM73fz8enJwHzK10uRlL0=
Message-ID: <a781481a0705191804u7f5a344cr92f2a1981c502bf7@mail.gmail.com>
Date: Sun, 20 May 2007 06:34:01 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Stefan Richter" <stefanr@s5r6.in-berlin.de>
Subject: Re: RFC: kconfig select warnings bogus?
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Sam Ravnborg" <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       "Roman Zippel" <zippel@linux-m68k.org>,
       "Kumar Gala" <galak@kernel.crashing.org>,
       "Simon Horman" <horms@verge.net.au>, "Adrian Bunk" <bunk@stusta.de>
In-Reply-To: <a781481a0705191753r25e0cay82785ed56c04b6eb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070519151523.GA26724@uranus.ravnborg.org>
	 <20070519110944.2a52061e.akpm@linux-foundation.org>
	 <a781481a0705191517n15eefe04i5458900c6ffe782d@mail.gmail.com>
	 <a781481a0705191549h602d331flf93c9d6c0261458f@mail.gmail.com>
	 <464F9A7B.1030708@s5r6.in-berlin.de>
	 <a781481a0705191753r25e0cay82785ed56c04b6eb@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/20/07, Satyam Sharma <satyam.sharma@gmail.com> wrote:
> On 5/20/07, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> > Satyam Sharma wrote:
> > > A combined patch for all of those on top of 22-rc2 (adding Signed-off-by's
> > > for original authors too):
> > >
> > > Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
> > > Signed-off-by: Simon Horman <horms@verge.net.au>
> > > Signed-off-by: Satyam Sharma <ssatyam@cse.iitk.ac.in>
> >
> > [...]
> >
> > Adrian already commented on this.  Let me just add that these above
> > changes are in so far *totally wrong* as they remove the "depends on
> > XYZ" which is implied by "select XYZ".
>
> Did you even try this patch?
>
> Did you try to select UCC_GETH and see if UCC_FAST got
> automatically selected or not?
>
> Did you get any build problems (or bogus warnings, for that matter)?
>
> Have you ever looked into arch/.../Kconfig's?
>
> > Remember, "select" is like "depends on", just with the added twist that
> > the 'make snafuconfig' scripts are instructed to (a) not hide the
> > depending option from the user and (b) try to enable the dependency for
> > the user if he tries to enable the depending option.
>
> This is precisely what happens with this patch too.
>
> Believe me, just go ahead and try it.
>
> Report any errors, dissatisfaction, etc, if any.
>
> Thanks.

[ Just to add: ]

You'll learn about the "default .. if .." Kconfig idiom after you try this, but
when this patch works for you, an Acked-by would also be nice, thanks.
