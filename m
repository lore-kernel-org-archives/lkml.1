Return-Path: <linux-kernel-owner+w=401wt.eu-S1758731AbXFVOpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758731AbXFVOpt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 10:45:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756432AbXFVOpl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 10:45:41 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:53978 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756028AbXFVOpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 10:45:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=J2xoYzBtpX1wy+blfel+tVy/xEWTnwFv2Rlo64Yge/jvOgCEPEC0Ak3L2MoofbNsQMohC/mMQ2riH9ec76YO0ruYExwr8v5DCV9mUgIOuu2Ld2Ul2ePigQVaCjhw/Thx64pvQWZ4nuzgFZCaeJcDT5oYRZfk3z6tdc7O6LF3Txk=
Message-ID: <787b0d920706220745w75231e2fp2f180e955010320f@mail.gmail.com>
Date: Fri, 22 Jun 2007 10:45:39 -0400
From: "Albert Cahalan" <acahalan@gmail.com>
To: "Pavel Machek" <pavel@ucw.cz>
Subject: Re: [TOMOYO 5/9] Memory and pathname management functions.
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       takedakn@nttdata.co.jp, hch@infradead.org
In-Reply-To: <20070621182205.GB18990@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <787b0d920706150016n3e941a4fj4fc2e864a7e6f7d7@mail.gmail.com>
	 <20070615130000.GI9442@ucw.cz>
	 <787b0d920706160208u62f8a2c5q5f94f5986d755d24@mail.gmail.com>
	 <20070621182205.GB18990@elf.ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/21/07, Pavel Machek <pavel@ucw.cz> wrote:

> > >> It's really not worth getting bothered by. Truth is, big
> > >> giant
> > >> pathnames break lots of stuff already, both kernel and
> > >> userspace.
> > >
> > >> Just look in /proc for some nice juicy kernel breakage:
> > >> cwd, exe, fd/*, maps, mounts, mountstats, root, smaps
> > >
> > >Well, but we should be fixing that, not adding more. And /proc is
> > >info-only, while this is security related code.
> >
> > Security tools read from /proc, so /proc is security-related.
>
> If some tool relies on pathnames in /proc, that tool is broken... as
> is /proc. We should be fixing that.

Running TOMOYO or AppArmor fixes the bug. :-)
You can't get long paths that break /proc if you are
running either. Therefore, one of those is required.
