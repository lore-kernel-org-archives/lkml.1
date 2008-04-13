Return-Path: <linux-kernel-owner+w=401wt.eu-S1754028AbYDMWKF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028AbYDMWKF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 18:10:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752051AbYDMWJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 18:09:53 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37679 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751679AbYDMWJx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 18:09:53 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: x86 git tree broken (bisected)
Date: Mon, 14 Apr 2008 00:10:00 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Ingo Molnar" <mingo@elte.hu>, "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, "Pavel Machek" <pavel@ucw.cz>,
       "Thomas Gleixner" <tglx@linutronix.de>, "H. Anvin" <hpa@zytor.com>,
       "Arjan van de Ven" <arjan@infradead.org>
References: <200804102159.14563.rjw@sisk.pl> <200804131812.55684.rjw@sisk.pl> <86802c440804131500q420f7442hd8512cc6f4a1a6fd@mail.gmail.com>
In-Reply-To: <86802c440804131500q420f7442hd8512cc6f4a1a6fd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804140010.01034.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 14 of April 2008, Yinghai Lu wrote:
> On Sun, Apr 13, 2008 at 9:12 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> ...
> >  > can you try to apply the patch i sent to you about agp bridge order
> >  > reading for buggy silicon?
> >  >
> >  > Please boot kernel with "debug"...
> >  >
> >  > I want to verify if you can get
> >  >
> >  > "
> >  > Aperture conflicts with PCI mapping.
> >  > "
> >  >
> >  > in your boot log...
> >
> >  It's not present in there:
> >
> >  rafael@albercik:~> grep Aperture failing-with-patch-dmesg.log
> >  Aperture too small (32 MB)
> >  Aperture from AGP @ de000000 size 4096 MB (APSIZE 0)
> >  Aperture too small (0 MB)
> >  agpgart: Aperture pointing to RAM
> >  agpgart: Aperture from AGP @ de000000 size 4096 MB
> >  agpgart: Aperture too small (0 MB)
> >
> >  Full dmesg output attached.
> 
> please check attached debug patch. and check if you can change GART
> size in your BIOS setup to 64M instead of 32M

Hm, what tree am I supposed to apply it too:
(1) current x86 git
(2) current x86 git w/ some of your previous patches (which ones in this case)
(3) failing (old) x86 git
(4) failing (old) x86 git w/ some of your previous patches (which ones in this
    case)?

Rafael
