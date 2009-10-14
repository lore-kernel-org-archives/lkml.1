Return-Path: <linux-kernel-owner+w=401wt.eu-S1759857AbZJNUm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759857AbZJNUm1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 16:42:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756947AbZJNUm0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 16:42:26 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:36179 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757236AbZJNUmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 16:42:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=k0BFpEKxybYBUnyTl4ZqZ+sBM39K2+xNZDBLtHh1jvtLbVhWn05n9b26VyRN+0X5E1
         beTBdyM3NzKsayfdc6DO8zKl6ylx54i7g0GUwKJDFJiUFKPRhqBWd6oKTkNxSGH2LnTx
         FzpxPD5ZDG2mkqTCYW73pXlnoaD0LLRzXZ/Q4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Luis Correia <luis.f.correia@gmail.com>
Subject: Re: Current status of rt2800usb and staging/rt2870
Date: Wed, 14 Oct 2009 22:41:00 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rc2-00290-g667503d; KDE/4.3.1; x86_64; ; )
Cc: "John W. Linville" <linville@tuxdriver.com>,
       Dan Williams <dcbw@redhat.com>, Ivo van Doorn <ivdoorn@gmail.com>,
       Ozan =?utf-8?q?=C3=87a=C4=9Flayan?= <ozan@pardus.org.tr>,
       linux-wireless@vger.kernel.org,
       "linux-kernel" <linux-kernel@vger.kernel.org>
References: <4AD46380.9020308@pardus.org.tr> <200910141933.09374.bzolnier@gmail.com> <efe7343f0910141126o54ea2e31r5327e0db06a8b7ec@mail.gmail.com>
In-Reply-To: <efe7343f0910141126o54ea2e31r5327e0db06a8b7ec@mail.gmail.com>
MIME-Version: 1.0
Message-Id: <200910142241.01013.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 October 2009 20:26:49 Luis Correia wrote:
> On Wed, Oct 14, 2009 at 18:33, Bartlomiej Zolnierkiewicz
> <bzolnier@gmail.com> wrote:
> > On Wednesday 14 October 2009 18:47:11 John W. Linville wrote:
> >> On Wed, Oct 14, 2009 at 05:28:21PM +0200, Bartlomiej Zolnierkiewicz wrote:
> >>
> >> > I don't have a have a problem with it personally as long as people accept
> >> > the competition..  but instead of working on _their_ projects they go around
> >> > screaming at everybody who does not want to spin inside the great process
> >> > designed by them..
> >>
> >> Please whine somewhere else.  You have the freedom to work in
> >> drivers/staging all you want.  You do not have the power to force us to
> >> like it -- especially in a case where you are diverting attention from
> >> the community-maintained drivers instead of cooperating with them.
> >
> > Cooperating you say.
> >
> > rtl8187 -- before starting the work on rtl8187se I've pinged the maintainer
> > to coordinate the effort and hear his opinion on how to progress..
> >
> > I've never heard back.
> >
> > rt2x00 -- I know that people have datasheets for some chipsets but I've
> > never heard "How can we help you" etc. thing.
> 
> I have all the datasheets that Ralink supplied to us.
> All of them are PRELIMINARY and most have errors, and therefore useless.
> 
> All useful information is in the crap drivers.
> 
> Ralink never provide better ones, and even our 'inside guy' says the
> hardware documentation guys are always very late in providing more
> info.
> 
> So, for me, it isn't lack of documentation that will ever help, believe me.
> 
> >
> > All I've ever heard was _lies_ about current state of affairs or that
> > my work is in the way.
> 
> AFAICS, your work was never questioned, at least by me.
> You are welcome to work on rt2x00 , that was also never a problem. All
> you would need is join in.
> 
> Ralink also said they were commited to present drivers for new chipset
> to be mac80211 compliant, we're waiting on that.
> 
> So, you're really welcome to join the rt2x00 team Bartlomiej, the only
> thing we ask is that all work should be done using the existing
> rt2x00lib, rt2x00pci and rt2x00usb base 'libraries'.

Well, I will still continue to work on staging drivers:

- I need to understand vendor drivers better before doing any larger rt2x00
  modifications.  Cleaning it up is just an added value while reading it..

- I feel quite comfortable working on de-convoluting crappy code and has years
  of experience of doing it.

- I'm still using Ralink hardware personally so I need something that provides
  the basic usability _now_.

but since I'm also going to start adding some missing bits to rt2x00 soon
I would be happy to join rt2x00 project..
