Return-Path: <linux-kernel-owner+w=401wt.eu-S1753421AbZE1OcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421AbZE1OcQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 10:32:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754726AbZE1OcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 10:32:00 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:57086 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754624AbZE1OcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 10:32:00 -0400
MIME-Version: 1.0
In-Reply-To: <20090528124307.GN22742@pengutronix.de>
References: <fa686aa40905270727m31250984tf12249fc87179ce9@mail.gmail.com> 
	<20090527150527.GK6805@pengutronix.de> <87vdnm8sec.fsf@macbook.be.48ers.dk> 
	<4A1D6901.2090508@freescale.com> <20090527175609.GB31861@flint.arm.linux.org.uk> 
	<4A1D8FBA.6040802@freescale.com> <20090527192909.GA32398@flint.arm.linux.org.uk> 
	<20090527205218.GA5591@sirena.org.uk> <fa686aa40905271405pc2f1738gc8dd139f61a0e27@mail.gmail.com> 
	<20090528124307.GN22742@pengutronix.de>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 28 May 2009 08:31:41 -0600
Message-ID: <fa686aa40905280731t51b0b16cscf4b047c301c92db@mail.gmail.com>
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
To: Grant Likely <grant.likely@secretlab.ca>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       devicetree-discuss <devicetree-discuss@ozlabs.org>,
       linux-kernel@vger.kernel.org, Timur Tabi <timur@freescale.com>,
       Scott Wood <scottwood@freescale.com>,
       Janboe Ye <yuan-bo.ye@motorola.com>,
       linux-arm-kernel@lists.arm.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 28, 2009 at 6:43 AM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> On Wed, May 27, 2009 at 03:05:58PM -0600, Grant Likely wrote:
> > There is the advantage of easy multiplatform support.  I regularly
> > build a single kernel image which boots on all my MPC5200 boards, and
> > on my MPC83xx boards.
>
> That is not necessarily an advantage of a device tree. On ARM you can
> also build a kernel which runs on 20+ PXA platforms at the same time.
> (And I'm sure it can be done to even support say i.MX and PXA at the
> same time, but this is another story)

With hard coded device tables the kernel needs to be explicitly taught
about each new board, and each enabled board increases the size of the
kernel image with separate copies of the device table.  With an
external data structure, a previously unknown board can be booted
without recompiling the kernel (assuming of course that the SoC is
supported).

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
