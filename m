Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756727Ab0BCPKV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 10:10:21 -0500
Received: from qw-out-2122.google.com ([74.125.92.25]:8252 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756501Ab0BCPKS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 10:10:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :content-type:content-transfer-encoding;
        b=xtKrUrV4U9Dw8Ag0jmJStfqMcufx6Zw0vKyeO8Pwt/aTIVad8sm0hLwZQ9+BZmr2/R
         ASelovzodRY2gGV6z1RQRO1QgNBxSSZ6PQvaz+lND7+WenfSv7valSm2wC/jGqQQc3+R
         7l4U07rzV9NCnby1xFACRX3W4KKXbQESEPaYY=
MIME-Version: 1.0
In-Reply-To: <20100203132404.GC5252@k2>
References: <cover.1265173480.git.amit.kucheria@canonical.com> 
	<cover.1265173246.git.amit.kucheria@verdurent.com> <0511204199ab83aed2340e70a4639500c0528dab.1265173480.git.amit.kucheria@canonical.com> 
	<f17812d71002022223jdc0ac5cp5b94928fb45695d6@mail.gmail.com> 
	<20100203132404.GC5252@k2>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Wed, 3 Feb 2010 07:09:57 -0800
Message-ID: <f17812d71002030709i6ecbc374g30e2b1343455b650@mail.gmail.com>
Subject: Re: [PATCHv2 01/11] arm: mxc: TrustZone interrupt controller (TZIC) 
	for i.MX5 family
To: Eric Miao <eric.y.miao@gmail.com>,
       List Linux Kernel <linux-kernel@vger.kernel.org>,
       linux@arm.linux.org.uk, Dinh.Nguyen@freescale.com,
       s.hauer@pengutronix.de, grant.likely@secretlab.ca,
       r.herring@freescale.com, linux-arm-kernel@lists.infradead.org,
       daniel@caiaq.de, bryan.wu@canonical.com, valentin.longchamp@epfl.ch
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 3, 2010 at 5:24 AM, Amit Kucheria
<amit.kucheria@canonical.com> wrote:
> On 10 Feb 02, Eric Miao wrote:
>> Hi Amit,
>>
>> Just some nit-picking review comments, see below:
>>
>> On Tue, Feb 2, 2010 at 9:16 PM, Amit Kucheria
>> <amit.kucheria@canonical.com> wrote:
>> > Freescale i.MX51 processor uses a new interrupt controller. Add
>> > driver for TrustZone Interrupt Controller
>> >
>> > Signed-off-by: Amit Kucheria <amit.kucheria@canonical.com>
>> > ---
>> >  arch/arm/plat-mxc/Kconfig  |    8 ++
>> >  arch/arm/plat-mxc/Makefile |    3 +
>> >  arch/arm/plat-mxc/tzic.c   |  182 ++++++++++++++++++++++++++++++++++++++++++++
>> >  3 files changed, 193 insertions(+), 0 deletions(-)
>> >  create mode 100644 arch/arm/plat-mxc/tzic.c
>> >
>> > diff --git a/arch/arm/plat-mxc/Kconfig b/arch/arm/plat-mxc/Kconfig
>> > index 8b0a1ee..59558c4 100644
>> > --- a/arch/arm/plat-mxc/Kconfig
>> > +++ b/arch/arm/plat-mxc/Kconfig
>> > @@ -62,6 +62,14 @@ config MXC_IRQ_PRIOR
>> >          requirements for timing.
>> >          Say N here, unless you have a specialized requirement.
>> >
>> > +config MXC_TZIC
>> > +       bool "Enable TrustZone Interrupt Controller"
>> > +       depends on ARCH_MX51
>>
>> This is the first patch of the base port, yet I cannot find any reference to
>> this ARCH_MX51, did you miss something?
>
> ARCH_MX51 is only introduced in the later patches that add the core i.MX5
> code. Since TZIC is not inherently dependent on i.MX5 (it's merely the first
> processor to use it), I thought of splitting it out as a separate patch.
>
> Does this break the sanctity of one self-contained change?
>

This breaks git-bisect, we may want a buildable kernel every commit if possible.

>> > +       help
>> > +         This will be automatically selected for all processors
>> > +         containing this interrupt controller.
>> > +         Say N here only if you are really sure.
>> > +

...

>
> Thanks for the review.
>

No problem, dude.
