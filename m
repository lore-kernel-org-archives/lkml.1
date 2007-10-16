Return-Path: <linux-kernel-owner+w=401wt.eu-S934705AbXJPRaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934705AbXJPRaA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 13:30:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764497AbXJPR3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 13:29:44 -0400
Received: from rv-out-0910.google.com ([209.85.198.190]:7607 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764366AbXJPR3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 13:29:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=IwY+C/huR4TZ47D0DooSFCk7hAGOkjZ1s+a+mwjLLn1QEcNLbSEufso+zhHEnNrTE3f2U14w1ahewDdigkIE0BoCg4c590d+E9i32MJHz/mnXnqBlrpMMjHusTxDeC6Uokur5RJ3ZwBEy7xoR5eC3ItyyajYM/ZDPha4WNk+gj0=
Date: Tue, 16 Oct 2007 13:29:33 -0400
From: Joseph Fannin <jfannin@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Joseph Fannin <jfannin@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Domen Puncer <domen.puncer@telargo.com>
Subject: Re: 2.6.23-mm1 pm_prepare() and _finish() w/ args vs. without
Message-ID: <20071016172932.GA1429@nineveh.local>
Mail-Followup-To: "Rafael J. Wysocki" <rjw@sisk.pl>,
	Joseph Fannin <jfannin@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	Domen Puncer <domen.puncer@telargo.com>
References: <20071011213126.cf92efb7.akpm@linux-foundation.org> <20071014194719.GB11864@nineveh.local> <200710142220.50299.rjw@sisk.pl> <200710152255.06734.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710152255.06734.rjw@sisk.pl>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2007 at 10:55:06PM +0200, Rafael J. Wysocki wrote:
> On Sunday, 14 October 2007 22:20, Rafael J. Wysocki wrote:
> > On Sunday, 14 October 2007 21:47, Joseph Fannin wrote:
> > > On Sat, Oct 13, 2007 at 09:13:13PM +0200, Rafael J. Wysocki wrote:
> > >
> > > > Yes.  Corrected patch follows.
> > >
> > > A bit more is needed due to the rename of lite5200_pm_init() to
> > > lite5200_suspend_init().
> >
> > Well, I didn't intend to change it. :-)
> >
> > > An amended patch follows that builds and boots on my powermac.
> >
> > Thanks.
> >
> > Can you please try the alternative one below?
> >
> > I just removed the renaming of lite5200_pm_init() from it.
>
> Well, from the lack of response I gather it works. :-)
>
> I'm going to send it in a separate thread with a changelog.  Please object if
> it doesn't work.

This patch builds and boots on my powermac.  Also, I checked, and
the remaning warnings from gcc in this general area are also present
in Linus's -git.

> Greetings,
> Rafael


Thanks!

--
Joseph Fannin
jfannin@gmail.com

