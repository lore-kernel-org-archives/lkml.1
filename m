Return-Path: <linux-kernel-owner+w=401wt.eu-S1761175AbXG2IwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761175AbXG2IwQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 04:52:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760519AbXG2IwD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 04:52:03 -0400
Received: from smtp107.plus.mail.re1.yahoo.com ([69.147.102.70]:41537 "HELO
	smtp107.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760316AbXG2IwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 04:52:01 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:References:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:In-Reply-To:User-Agent;
  b=EOXJFoVlsd2//MzrzExg/kgAhcHEJwjEs+LFu8KrYPQQQwqEIfUZ6e3VleORyENpwEunUbMg0R80E138unDx65zaqe8w6dDXlyZX7B/SIFRnQjaVQNmWPny8g/mKcoyosR/Wt73SOL0Ih8qKAs0gzl/Ak+PitnI69CgDU95BPuE=  ;
X-YMail-OSG: Hv9tzm0VM1kSY5z1.bJtnylsLZrHObBsOIDvaG6vkgFFDNgnKt.IC3Fe.UVL_KVpELevrFcZoA--
Date: Sun, 29 Jul 2007 10:51:00 +0200
From: Borislav Petkov <bbpetkov@yahoo.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Xudong Guan <xudong.guan@gmail.com>, linux-kernel@vger.kernel.org,
       Chuck Ebbert <cebbert@redhat.com>
Subject: Re: 2.6.23-rc1: no setup signature found...
Message-ID: <20070729085059.GA10758@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
References: <20070724112618.GA4431@gollum.tnic> <20070726150854.GA7034@xguan-laptop> <46A8BB6C.6050903@zytor.com> <20070726163053.GA4570@gollum.tnic> <46A8E3F9.5070809@zytor.com> <20070727013615.GC4570@gollum.tnic> <46A9753A.1010206@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <46A9753A.1010206@zytor.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2007 at 09:31:54PM -0700, H. Peter Anvin wrote:

[added to cc: Chuck Ebbert]
> Borislav Petkov wrote:
> >>
> >> The absolute best would be if we could replicate this in simulation
> >> (Bochs or Qemu); this would make it very simple to debug.  Would you be
> >> willing to try to do that?
> > sure, will do, however i'll be busy at work/travelling tomorrow but as soon as i
> > get home i'll whip up my qemu and run the kernel in question in it. However,
> >  Xudong said that grub 0.97 boots just fine on his machine and i think it'll be
> >  better to debug this right on the bare hardware (i.e. my laptop) ...?
> >  Suggestions ?
> 
> If we can't reproduce the problem in simulation, that itself will tell
> us something very important.  If we *can* reproduce it in simulation, it
> will be vastly easier to debug.

Hi Peter,

   sorry for the delay, here's my report. I got the qemu linux image from the
   qemu website and did the following:

[boris@gollum:10:34:25:qemu:9553)->  qemu -kernel /boot/2.6.22-4fd06960f120e02e9abc802a09f9511c400042a5-12 -append "root=/dev/hda" linux-0.2.img

and the kernel did boot just fine so the problem should be pertaining only to the
case when we boot on the bare hardware...
-- 
Regards/Gruﬂ,
    Boris.
