Return-Path: <linux-kernel-owner+w=401wt.eu-S1762381AbYJKSew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762381AbYJKSew (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 14:34:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754924AbYJKSem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 14:34:42 -0400
Received: from fk-out-0910.google.com ([209.85.128.186]:22696 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754282AbYJKSem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 14:34:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent:from;
        b=jCDEzznvOXGuilHkYnf10LsHgAvC4qkvYi3dBIbUOXEYWb3ehDYVh7jyJoHInCAvqm
         8IA52lPBHOoqEix3MOdeHKryfvzsB3/S/CrEl8CU/+afvFVL8h31aLqyWkh77zwBvRp0
         Lwo1Et1lhBy3qT4O8CVtgDUd/UFgIqB5o+ERc=
Date: Sat, 11 Oct 2008 20:34:36 +0200
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Robert Hancock <hancockr@shaw.ca>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] ide: locking improvements
Message-ID: <20081011183436.GA10948@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com, Jens Axboe <jens.axboe@oracle.com>,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	Robert Hancock <hancockr@shaw.ca>, linux-ide@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <fa.Ke90oacfRjgiI4x5LejzjssRBEg@ifi.uio.no> <200810111645.27847.bzolnier@gmail.com> <20081011150532.GU19428@kernel.dk> <200810111756.37278.bzolnier@gmail.com> <20081011175617.GX19428@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081011175617.GX19428@kernel.dk>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > The actual users' feedback about amount of IDE changes have been mostly
> > positive (some ask for even more changes :) so I don't think that it
> > should be a reason of a great worries.  I hope that all other concerns
> > have been also cleared now.
> 
> Heck that's good, I do hope that I'm mostly over-concerned! I'm not
> trying to create a problem where there isn't one, mainly looking for
> clarity into the situation.
> 
> I noticed one ide-tape tested complaining something broke, and it seems
> like he was the only one out there actually using current kernels and
> testing it. I worry mostly about the changes breaking somebodys distro 3
> years down the line, by which point people may have moved on (and the
> old code would have worked).

We try to fix those as fast as possible and they become
highest priority. If we're talking about the same thing, aka
801bd32e205ca6ef78dcaf80121f1eccb89b8c1e, this is obviously already fixed.

It's not like everything is fine with the older code either. For example, I'm
staring at traces w.r.t. bug 11581 which somehow broke ide-cd around the 2.6.19
timeframe and this has been broken for that particular user since then. So I
think that what we do now, generally that anyone is doing something about that
code, replying to bug reports and working with users to solve problems is, IMO,
a lot bigger advantage than doing nothing at all. But your concern is also valid
and we're doing our best to avoid such regressions.

-- 
Regards/Gruss,
    Boris.
