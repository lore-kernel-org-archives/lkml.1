Return-Path: <linux-kernel-owner+w=401wt.eu-S1765582AbYAaJ1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765582AbYAaJ1V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 04:27:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753239AbYAaJ1H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 04:27:07 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:31107 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753331AbYAaJ1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 04:27:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=o+Be5E+EYfbIiyXlZ4i4n/UwLIWbJ+BoQbSPrhYiuBJdCNoPkkur4Z5/bP9EMi9nBl9kgQH6PZ8FJLFJC8mhR3tPMD17bCMtoE2sv7aPUrqrIfB8SAtuZp0CU5wGphMCiQBm5VXoh3o3IdDQkI+zuu6FlRup0AIE1986rOaqOT0=
Message-ID: <f17812d70801310127h64f77b10td33a4736b3a23836@mail.gmail.com>
Date: Thu, 31 Jan 2008 17:27:01 +0800
From: "eric miao" <eric.y.miao@gmail.com>
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: [spi-devel-general] SPI related Kconfig warning
Cc: "Kumar Gala" <galak@kernel.crashing.org>,
       spi-devel-general@lists.sourceforge.net,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <200801302321.51120.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <D5CED6F1-A708-4866-BA3D-75F3CCBA43F6@kernel.crashing.org>
	 <200801302321.51120.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 31, 2008 3:21 PM, David Brownell <david-b@pacbell.net> wrote:
> On Wednesday 30 January 2008, Kumar Gala wrote:
> > Was wondering if anyone was looking at the cause of this warning in
> > top of linus's tree (8af03e782cae1e0a0f530ddd22301cdd12cf9dc0)
> >
> > drivers/spi/Kconfig:156:warning: 'select' used by config symbol
> > 'SPI_PXA2XX' refers to undefined symbol 'PXA_SSP'
> >
> > I was doing a build of a ppc kernel.
>
> Happens on x86, AVR32, and non-PXA ARM too.  Came from some PXA cleanup
> patches.  Eric, didn't you have a patch for this?
>

Nope.

If moving the symbol PXA_SSP to the "depends on" list, this option will
remain invisible if a careless user does not select PXA_SSP.

Yet I'm not sure this is the way to go or mandatory by the kconfig rules.

> (Of course I *still* don't understand why kconfig bothers to look
> at reverse dependencies whose "forward" ones can never be satisfied.
> If it stopped looking at those, lots of similar problems would vanish.)
>
> - Dave
>



-- 
Cheers
- eric
