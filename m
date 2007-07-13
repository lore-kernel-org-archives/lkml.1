Return-Path: <linux-kernel-owner+w=401wt.eu-S937008AbXGMP3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937008AbXGMP3l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 11:29:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936846AbXGMP26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 11:28:58 -0400
Received: from [212.12.190.103] ([212.12.190.103]:32935 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S936712AbXGMP25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 11:28:57 -0400
From: Al Boldi <a1426z@gawab.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Kexec jump: The first step to kexec base hibernation
Date: Fri, 13 Jul 2007 18:28:56 +0300
User-Agent: KMail/1.5
References: <200707130808.31109.a1426z@gawab.com>
In-Reply-To: <200707130808.31109.a1426z@gawab.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200707131828.56810.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Friday, 13 July 2007 19:32, Huang, Ying wrote:
> > On Thu, 2007-07-12 at 20:06 -0700, david@lang.hm wrote:
> > > >> I agree, a stipped down hibernate kernel can be very small, not
> > > >> allocating this memory until it's needed is a step for the final
> > > >> polishing.
> > > >
> > > > I'm not sure if I agree with that.  In any case, having to use two
> > > > different kernels for hibernation would be a big drawback.
> > >
> > > I see it as a big advantage to not have to use the main kernel for the
> > > suspend. please keep it as an option at least.
> >
> > Yes. It has additional bonus to make it possible to write/read image
> > from a program other than main kernel. For example, for a specific
> > mobile device product (Such as Intel MID), a customized ultra-small
> > program (or kernel) can be composed to write/read image. That way, the
> > hibernate/resume time can be reduced to minimal.

Sounds great!

> You don't need kexec for that.  This is how the userland hibernation (aka
> uswsusp) works.

I don't think so.  uswsusp runs under the normal kernel which implies an 
interdependency, whereas a device driver stub'd with a small single proc 
kernel would run in its own space.

The question is, how small could this kernel stub be made and still leverage 
the device driver pool?


Thanks!

--
Al

