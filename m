Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755866Ab0CJJbY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 04:31:24 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:59957 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755564Ab0CJJbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 04:31:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Td0w5+PMytq6YG3U6RyNMf7gb02G828g4SsfM17aawMBkGsBDftO0L4GwcgbpPr1rb
         1U+lYwNvD4o8UPqH0snSO0KLTHUKDVNOn6f7yQH/p+qibXGz7M7we8gsFpg8SahRH8FJ
         gs2biD0c5+6nWJ84RwH8IlXXxosBvMEke+ZoI=
MIME-Version: 1.0
In-Reply-To: <4B973CF6.4030009@st.com>
References: <1267592861-26911-1-git-send-email-viresh.kumar@st.com>
	 <1267592861-26911-2-git-send-email-viresh.kumar@st.com>
	 <1267592861-26911-3-git-send-email-viresh.kumar@st.com>
	 <1267592861-26911-4-git-send-email-viresh.kumar@st.com>
	 <1267592861-26911-5-git-send-email-viresh.kumar@st.com>
	 <63386a3d1003092140o67a6c943rdee3a6c905cea7ef@mail.gmail.com>
	 <4B973CF6.4030009@st.com>
Date: Wed, 10 Mar 2010 10:31:18 +0100
Message-ID: <63386a3d1003100131v7027e44cu5031c9ee3bf6ec73@mail.gmail.com>
Subject: Re: [PATCH 04/11] ST SPEAr: Added basic header files for SPEAr 
	platform
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
> Linus Walleij:
>> If this file is only supposed to be used from plat-spear/time.c, move it down
>> into plat-spear/gpt.h and #include "gpt.h" so noone else will
>> accidentally use it.
>
> GPT's on SPEAr can be used from time.c, platform specific drivers and machine
> specific drivers or any driver wishing to use hardware timer.
> In first two cases "gpt.h" will work, but in rest of cases we need gpt.h to be
> in plat-spear/include/plat
>
> Is it okay?

If you have or have already planned to write such platform, machine
or subsystem drivers, it's OK, if there are no such users and you cannot
easily give one, it's overdesigned IMHO. Some realistic examples of such
drivers will make me change my mind :-)

The reason I persist is that I've seen such unutilized timer API:s before and
no other user than the system timer in sight. I never understood what they
were to be used for, and I still don't, so help me understand. The kernel
has many internal timer API:s based on clockevent available already so
why add yet another, platform-specific one?

Yours,
Linus Walleij
