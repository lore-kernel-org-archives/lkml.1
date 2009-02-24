Return-Path: <linux-kernel-owner+w=401wt.eu-S1756349AbZBXMi7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756349AbZBXMi7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 07:38:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754026AbZBXMiu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 07:38:50 -0500
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:30570 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752457AbZBXMiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 07:38:50 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=bkX69/Ly37sOphO2hHhMI3rLMiFHmmfzq8TyhEPNhceYn2HxgjxTZrgFHxeGXM2gHRCl0eA65GigRk83ygnF0hgu0r2P0ZCZil1GqkhciwoIeV/KIXqgzWqSgNo5yKlpmCrr+R017hb7rNSzYljRvsxwb8wI8sdXS16ocUs/YwU=  ;
X-YMail-OSG: jJ2lqsoVM1nqpJgSzftwnLaKV2uLtiA2NNkMeQl1I7PgJWqpCaGYlBfxZ3p661L1dhlZ1jaLvS5urH9hik0Z7viU8HqynBkgZTMXKgQp30MhXAS4SBKvllakwYo2nCsriDealF2yprBdT2_IeZ3et0AoMnh_mBap_JVxFbsDJ_Migk8xjlp29sWQ.JzSvM1dLCOf4Xe.VeO2u7imJ9._tHCxsk4jLAF3
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: luis6674@yahoo.com, Eric Anholt <eric@anholt.net>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [Bug #12337] ~100 extra wakeups reported by powertop
Date: Tue, 24 Feb 2009 23:38:13 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <77208.42754.qm@web53309.mail.re2.yahoo.com>
In-Reply-To: <77208.42754.qm@web53309.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902242338.14105.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 February 2009 23:25:11 Alberto Gonzalez wrote:
> --- On Tue, 2/24/09, Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > > > Bug-Entry	:
> > > > http://bugzilla.kernel.org/show_bug.cgi?id=12337
> > > > Subject		: ~100 extra wakeups reported by
> >
> > powertop
> >
> > > > Submitter	: Alberto Gonzalez
> >
> > <luis6674@yahoo.com>
> >
> > > > Date		: 2008-12-31 12:25 (55 days old)
> > >
> > > Still present, yes.
> >
> > Any chance you could bisect it?
>
> Well, if you look at the report you'd notice that:

I read at the report, but it wasn't obvious that you wouldn't be
able to bisect it.


> - I'm using a released, stable, distro (Arch Linux, basically vanilla)
> kernel. I hardly know how to compile one, let alone bisect it. - I first
> had the problem on my 5+ year old Pentium 4 with equally old Intel graphics
> (845G chipset). I thought it would be hardware specific. But now I got a
> new Core 2 Duo with new Intel graphics (G45 chipset), moved to 64bit, and
> still have the exact same problem and exact same workaround. So I really
> don't believe anymore it's something hardware specific and should be quite
> general to anyone using Intel graphics. I hoped someone with much better
> knowledge could reproduce it and investigate it better.
>
> On the report, Eric Anholt mentioned a likely cause and said that Jesse
> Barnes had looked into a similar issue before. I cc'd him (jbarnes) on last
> week reminder, but got no reply.
>
> I really wish I could do more, but learning to compile a custom kernel for
> my hardware and do a git bisect is something I just can't afford now. If
> relevant people try to reproduce it but can't, and say only possible
> solution would be for me to bisect it I guess I could try to give it a go
> when I get some spare time.

Fair enough. Reporting a problem is always very appreciated.

Pinging Eric and Jesse ;)

