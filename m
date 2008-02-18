Return-Path: <linux-kernel-owner+w=401wt.eu-S1759264AbYBRKk6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759264AbYBRKk6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 05:40:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755917AbYBRKku
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 05:40:50 -0500
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:39378 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753033AbYBRKku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 05:40:50 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=4tBUptGA/lK2dKjG9Rr1HMc7qF4+02ZhMNaYcj2RakR+Yl99piedcRlw8q8X3Cdfkg8vOU5HlZGqsCdk7jw7urWPWaQD1YAcnk4rsOONnNckf7hnbVefyR5EPSVCdl70CEOaHY+IOJg/Tbk6kkCAkdJDThmlk8viwEFgWvHQdfE=  ;
X-YMail-OSG: LUz6h2wVM1nkVB9B7GDhlm.wARV9aL.ft3WvyF4xT0g.f1Do8fRfKcpqXTDgtSRbjIhLUetgNw--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] suspend/resume self-test
Date: Mon, 18 Feb 2008 02:40:46 -0800
User-Agent: KMail/1.9.6
Cc: rjw@sisk.pl, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <20080130131748.GA3796@elf.ucw.cz> <20080218094650.GA31970@elte.hu> <20080218095325.GA7198@elf.ucw.cz>
In-Reply-To: <20080218095325.GA7198@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200802180240.47510.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >   - Includes a command line parameter, which needs work yet ... it
> >     currently turns this test off, but it should also let the target
> >     state be specified (and maybe even default to "no test").

I think "no test" should be the default; STR working sanely on
x86 is unfortunately too much a surprise.  Someone more active
in PM testing should update that.


> > Also includes some Kconfig tweaks to help reduce configuration bugs on
> > x86, by avoiding the legacy RTC driver when the generic RTC framework
> > is enabled ... those should become a separate patch.

That's already been split out in a separate patch, now in MM.
Though it may deserve another tweak, forcing off *all* legacy
RTC drivers if the new framework is enabled.

