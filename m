Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758025Ab0BDAzJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 19:55:09 -0500
Received: from mail-qy0-f201.google.com ([209.85.221.201]:46890 "EHLO
	mail-qy0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142Ab0BDAzE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 19:55:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :content-type:content-transfer-encoding;
        b=gGPHMDqaKi9wXjtVcxHOniEDOf4DxlkVMZ0gtAEYP96WlqEK4XK30IQmH7b7kch4fs
         ZcgVFcKP6QqOk+bZ6Jz6jD7El9v/TtbpA0CJltItcRIF2FMK+4j3vr9trwBxCowp2yQh
         wdZhQ+rzJSDEzUbrJuASFlZQVq/Al5NDO6KfQ=
MIME-Version: 1.0
In-Reply-To: <f17812d71002030709i6ecbc374g30e2b1343455b650@mail.gmail.com>
References: <cover.1265173480.git.amit.kucheria@canonical.com> 
	<cover.1265173246.git.amit.kucheria@verdurent.com> <0511204199ab83aed2340e70a4639500c0528dab.1265173480.git.amit.kucheria@canonical.com> 
	<f17812d71002022223jdc0ac5cp5b94928fb45695d6@mail.gmail.com> 
	<20100203132404.GC5252@k2> <f17812d71002030709i6ecbc374g30e2b1343455b650@mail.gmail.com>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Wed, 3 Feb 2010 16:54:41 -0800
Message-ID: <f17812d71002031654t53d4d7b1wd9933633636f9d63@mail.gmail.com>
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

> >> > +config MXC_TZIC
> >> > +       bool "Enable TrustZone Interrupt Controller"
> >> > +       depends on ARCH_MX51
> >>
> >> This is the first patch of the base port, yet I cannot find any reference to
> >> this ARCH_MX51, did you miss something?
> >
> > ARCH_MX51 is only introduced in the later patches that add the core i.MX5
> > code. Since TZIC is not inherently dependent on i.MX5 (it's merely the first
> > processor to use it), I thought of splitting it out as a separate patch.
> >
> > Does this break the sanctity of one self-contained change?
> >
>
> This breaks git-bisect, we may want a buildable kernel every commit if possible.
>

Hmm... you may safely ignore this, it's not going to break the build
since it won't be selected without ARCH_MX51 being defined.
