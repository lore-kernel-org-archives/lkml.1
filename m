Return-Path: <linux-kernel-owner+w=401wt.eu-S1762161AbYBRW5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762161AbYBRW5k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 17:57:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753760AbYBRW5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 17:57:32 -0500
Received: from vs166246.vserver.de ([62.75.166.246]:54319 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753576AbYBRW5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 17:57:31 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [RFC] [PATCH] Fix b43 driver build for arm
Date: Mon, 18 Feb 2008 23:56:45 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Russell King <rmk+lkml@arm.linux.org.uk>,
       Gordon Farquharson <gordonfarquharson@gmail.com>,
       linux-kernel@vger.kernel.org, linville@tuxdriver.com,
       stefano.brivio@polimi.it
References: <97a0a9ac0802181403ja79c32v864b093414b2755@mail.gmail.com> <200802182343.12749.mb@bu3sch.de> <1203375030.5757.75.camel@brick>
In-Reply-To: <1203375030.5757.75.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802182356.45858.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 February 2008 23:50:30 Harvey Harrison wrote:
> On Mon, 2008-02-18 at 23:43 +0100, Michael Buesch wrote:
> > On Monday 18 February 2008 23:34:10 Russell King wrote:
> > > 
> > > Well, don't expect this driver to work until you fix your broken
> > > assumptions about alignment requirements.
> > 
> > Mr King, I'm not an idiot!
> > 
> > Can you _please_ explain what makes ARM so special here?
> > Why can't we have an array of this structure on ARM?
> > 
> > struct ssb_device_id {
> >        __u16   vendor;
> >        __u16   coreid;
> >        __u8    revision;
> > };
> > 
> > I will not apply any patches that I don't understand.
> > Why doesn't the compiler handle this? What's special? Can you please explain?
> > 
> 
> I believe this is a good place to start (although I could be totally
> off-base)
> 
> http://lkml.org/lkml/2007/11/22/120

I know very well what unaligned access is. As I said the code
works on MIPS, which can't do unaligned accesses.

The _real_ question is, why doesn't align the compiler the stuff properly
on ARM? It does the right thing on x86_32/64, powerpc and MIPS. Why doesn't
it do the right thing on ARM and we have to manually align stuff?

See section "Code that doesn't cause unaligned access"

-- 
Greetings Michael.
