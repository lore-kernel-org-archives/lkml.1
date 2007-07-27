Return-Path: <linux-kernel-owner+w=401wt.eu-S1766002AbXG0BhR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766002AbXG0BhR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 21:37:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759440AbXG0BhG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 21:37:06 -0400
Received: from smtp107.plus.mail.re1.yahoo.com ([69.147.102.70]:35831 "HELO
	smtp107.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752486AbXG0BhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 21:37:05 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:References:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:In-Reply-To:User-Agent;
  b=bIZ0MVZmvxaGF/RJbF4isXacUDLex7Vv6IqSCoZJ9BSJg4qLLfGtAauCgohciVUyB0njpR5mMED03I+I6kabS0PtzahVV4B4OlFh8NdZLhfsB3OWYS9qU4cDPYpur/22ImOh1zJu3pY2524sdOB7pYg4y4vPnURPSOR8zuLfuEk=  ;
X-YMail-OSG: kvUVBoIVM1kQJhrvU735AwIuMY9l.aA6NWOT383oFUtUJ8aqOK2xRreh2KmFUSxg5rSmWhvaZQ--
Date: Fri, 27 Jul 2007 03:36:16 +0200
From: Borislav Petkov <bbpetkov@yahoo.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Xudong Guan <xudong.guan@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc1: no setup signature found...
Message-ID: <20070727013615.GC4570@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
References: <20070724112618.GA4431@gollum.tnic> <20070726150854.GA7034@xguan-laptop> <46A8BB6C.6050903@zytor.com> <20070726163053.GA4570@gollum.tnic> <46A8E3F9.5070809@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <46A8E3F9.5070809@zytor.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2007 at 11:12:09AM -0700, H. Peter Anvin wrote:
> Borislav Petkov wrote:
> > 
> >> What distro/version of grub are you running?  
> > Debian unstable
> >> I'm wondering if there are
> >> some old version of grub out there which did the "load four sectors"
> >> way-anciently-obsolete crap; the other possibility that comes to mind is
> >> setting up the stack in an invalid manner.
> > grub version:
> > 
> > [boris@gollum:18:17:27:->  apt-cache show grub
> > Package: grub
> > Priority: optional
> > Section: admin
> > Installed-Size: 708
> > Maintainer: Grub Maintainers <pkg-grub-devel@lists.alioth.debian.org>
> > Architecture: i386
> > Version: 0.97-29
> > Depends: libc6 (>= 2.5-5), libncurses5 (>= 5.4-5)
> > Suggests: grub-doc, mdadm
> > Filename: pool/main/g/grub/grub_0.97-29_i386.deb
> > Size: 366884
> > MD5sum: 2da7a5942db06eaba046dff4615bcce9
> > SHA1: 7f4da793da209d011ce94fceebaebe0e5f08790f
> > SHA256: 2596782c08f1f7365e9935f687fef74c67d8702503188f22448db9f0ac98e18e
> > Description: GRand Unified Bootloader
> > ...
> 
> This concerns me deeply.  This is a current version of Grub which
> shouldn't have any silly 8K limitations.  Yet it appears to have a
> similar pathology over the ancient version Xudong just described.
> 
> The absolute best would be if we could replicate this in simulation
> (Bochs or Qemu); this would make it very simple to debug.  Would you be
> willing to try to do that?
sure, will do, however i'll be busy at work/travelling tomorrow but as soon as i
get home i'll whip up my qemu and run the kernel in question in it. However,
 Xudong said that grub 0.97 boots just fine on his machine and i think it'll be
 better to debug this right on the bare hardware (i.e. my laptop) ...?
 Suggestions ?

-- 
Regards/Gruﬂ,
    Boris.
