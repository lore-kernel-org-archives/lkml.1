Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752339Ab0CJFPQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 00:15:16 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:34993 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835Ab0CJFPM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 00:15:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=KP3RsDjtZeLvWZbpaKyTwRfpjzvUBhJnYkzejvQ1t+kHLk34AzTUjxQgGFAqwB2Q5O
         dOSJ0fZgK7BF+8XjpsxfYUh4KoJyUFv+bnmOqu+530fKMDSYj3/R5UqrtOFFbJYz1xt1
         IzArlUkag6UW5bpjYNVm4fJ5t40cLsGYxUNsM=
MIME-Version: 1.0
In-Reply-To: <4B95F339.5040903@st.com>
References: <1267592861-26911-1-git-send-email-viresh.kumar@st.com>
	 <1267592861-26911-2-git-send-email-viresh.kumar@st.com>
	 <1267592861-26911-3-git-send-email-viresh.kumar@st.com>
	 <1267592861-26911-4-git-send-email-viresh.kumar@st.com>
	 <1267592861-26911-5-git-send-email-viresh.kumar@st.com>
	 <1267592861-26911-6-git-send-email-viresh.kumar@st.com>
	 <1267592861-26911-7-git-send-email-viresh.kumar@st.com>
	 <1267592861-26911-8-git-send-email-viresh.kumar@st.com>
	 <63386a3d1003082246g2752ccf4ob52d5bb01dfb264c@mail.gmail.com>
	 <4B95F339.5040903@st.com>
Date: Wed, 10 Mar 2010 06:15:10 +0100
Message-ID: <63386a3d1003092115ia91b7d9l64cc89ebd72d7e22@mail.gmail.com>
Subject: Re: [PATCH 07/11] ST SPEAr: Added source files for SPEAr3xx machine 
	family
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Viresh KUMAR <viresh.kumar@st.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       armando.visconti@st.com, amit.goel@st.com, shiraz.hashim@st.com,
       vipin.kumar@st.com, rajeev-dlh.kumar@st.com, deepak.sikri@st.com,
       ashish.priyadarshi@st.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/3/9 Viresh KUMAR <viresh.kumar@st.com>:

> On 3/9/2010 12:16 PM, Linus Walleij wrote:
>> Hi Viresh,
>>> (...)
>>> +       .irq = {IRQ_UART, NO_IRQ},
>>> +       .periphid = 0x00041011,
>>> +};
>>
>> You're hardcoding the PrimeCell ID to the ARM version, (...)
>
> Actually PL011 is customized by ST's nomadik platform. And hence above
> is true for nomadik only. We are using ARM's version of PL011 without
> any customization over it and so id for our case is still 0x00041011.

OK then you can probably just delete the .periphid line, the only thing that
will do is to override the number found in the ID registers with the same
number. If this doesn't work you certainly have a modified version anyway.

Linus
