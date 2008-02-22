Return-Path: <linux-kernel-owner+w=401wt.eu-S934131AbYBVDWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934131AbYBVDWo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 22:22:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754993AbYBVDWf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 22:22:35 -0500
Received: from el-out-1112.google.com ([209.85.162.179]:51973 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754345AbYBVDWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 22:22:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=AHALKtKQbzc+mHh6Ek41EIFfy5Ia+QNXxP175OKlp5OJZOVGP25vliNDFiJBivVFxy5J8vT8BYqo0amvnwkKieXK2CKf/zqTXJTu/HrePvMr0b4c7gjXv6FQRcG1uoSkjedr3iB5J3WFf1oDnF0ihMP5Ri46VAeDnaIODgYfXY0=
Message-ID: <f17812d70802211922v49201af2re87629eba34bd9d4@mail.gmail.com>
Date: Fri, 22 Feb 2008 11:22:33 +0800
From: "eric miao" <eric.y.miao@gmail.com>
To: "Liam Girdwood" <lg@opensource.wolfsonmicro.com>
Subject: Re: [UPDATED v2][PATCH 0/6] regulator: voltage and current regulator framework
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>
In-Reply-To: <1203611191.4071.186.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1203527326.4071.88.camel@localhost.localdomain>
	 <20080221084128.GA4931@flint.arm.linux.org.uk>
	 <1203611191.4071.186.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2008 at 12:26 AM, Liam Girdwood
<lg@opensource.wolfsonmicro.com> wrote:
> On Thu, 2008-02-21 at 08:41 +0000, Russell King - ARM Linux wrote:
>  > On Wed, Feb 20, 2008 at 05:08:46PM +0000, Liam Girdwood wrote:
>  > > This patch series provides a generic framework to allow device drivers
>  > > to control voltage and current regulators on SoC based devices (e.g.
>  > > phones, gps, media players).
>  >
>  > Note that I'm explicitly avoiding commenting on this as far as PXA3xx
>  > devices go, until we're further down the road with PM support on that
>  > SoC.  It's not clear at present whether a generic PMIC framework will
>  > be suitable for this SoC since it's my understanding from Marvell that
>  > we need to talk to the PMIC from IRQs-off contexts.
>  >
>  > So don't take my silence as some sort of acceptance of this code; it
>  > isn't.
>
>  I wasn't ;)
>
>  It then might be worth adding this functionality at a later stage when
>  more can be said about PXA3xx PMIC support. We could always have a
>  version of the _set() functions that are designed to handle this case.
>
>  In the mean time this works well on 3 other SoC CPUs.
>
>  Liam
>

Liam,

I have a rough peek into the git tree on opensource.wolfsonmicro.com,
find another PMIC framework, and here instead is a regulator framework,
looks like a simplified or dedicated one. What is their relationship?

For those PMIC that covers additional features, like
  - usb vbus detection (or pull-up/pull-down)
  - audio codec
  - touch screen
  - battery monitor/ fuel gauge
  - battery charger
  - possible many others

How do you plan to handle them?

>
>
>  --
>  To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>  the body of a message to majordomo@vger.kernel.org
>  More majordomo info at  http://vger.kernel.org/majordomo-info.html
>  Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Cheers
- eric
