Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754452Ab0CJGHx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 01:07:53 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:35609 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247Ab0CJGHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 01:07:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=umcIK4Y1kDF/EmSH9aftlBWpicTFnnx3EtyKD04de6mHG5RfyI7kZO9rqRlw3G13WM
         nOaaVUV6kFdk3EIlSj4fPFnso6KSlsWTOuCMmOCum3GaVD7zjC86XsZGtZfUJoypY/Qo
         C/6xtB/8pxz9i7WoQJxUaubVGR8JGFHHzS0xc=
MIME-Version: 1.0
In-Reply-To: <4B9735B2.1030108@st.com>
References: <1267592861-26911-1-git-send-email-viresh.kumar@st.com>
	 <1267592861-26911-2-git-send-email-viresh.kumar@st.com>
	 <1267592861-26911-3-git-send-email-viresh.kumar@st.com>
	 <63386a3d1003091242i5e8786e4n1fe0d83b97d51e3b@mail.gmail.com>
	 <4B9735B2.1030108@st.com>
Date: Wed, 10 Mar 2010 07:07:49 +0100
Message-ID: <63386a3d1003092207yd7a5a6dqf0aeb03ba67e602a@mail.gmail.com>
Subject: Re: [PATCH 02/11] ST SPEAr: Added basic header files for SPEAr3xx 
	machine family
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Viresh KUMAR <viresh.kumar@st.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       armando.visconti@st.com, amit.goel@st.com, shiraz.hashim@st.com,
       vipin.kumar@st.com, rajeev-dlh.kumar@st.com, deepak.sikri@st.com,
       ashish.priyadarshi@st.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/3/10 Viresh KUMAR <viresh.kumar@st.com>:
> On 3/10/2010 2:12 AM, Linus Walleij wrote:

>> If you want to keep this file anyway, move it from mach-spear3xx/include/mach
>> to just mach-spear3xx and include like this: #include "misc_regs.h" and
>> thus avoid the entire drivers/* tree (etc) from being able to #include
>> <mach/misc_regs.h>
>> because surely any machine-specific special driver using these very
>> machine-specific
>> registers will be in mach-spear3xx/ anyway.
>
> Surely, any standard driver will not use them. Actually we have kept clock
> framework code common to different machines in plat-spear.
> And here we need to use misc_regs.h, for this reason i kept it in
> mach/include/mach.

Okay so the plat-spear code use <mach/misc_regs.h> that is different
between different machines? Then it's correct of course, sorry for going
astray, please keep it there then.

Yours,
Linus Walleij
