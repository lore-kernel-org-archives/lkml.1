Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756808Ab0CKKS4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 05:18:56 -0500
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:49759 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756680Ab0CKKSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 05:18:53 -0500
Message-ID: <4B98BC40.1030306@st.com>
Date: Thu, 11 Mar 2010 15:17:44 +0530
From: Shiraz HASHIM <shiraz.hashim@st.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.8) Gecko/20100216 Lightning/1.0b1 Thunderbird/3.0.2
MIME-Version: 1.0
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: Viresh KUMAR <viresh.kumar@st.com>, linux-arm-kernel@lists.infradead.org,
       linux-kernel@vger.kernel.org, armando.visconti@st.com, amit.goel@st.com,
       vipin.kumar@st.com, rajeev-dlh.kumar@st.com, deepak.sikri@st.com,
       ashish.priyadarshi@st.com
Subject: Re: [PATCH 04/11] ST SPEAr: Added basic header files for SPEAr 	platform
References: <1267592861-26911-1-git-send-email-viresh.kumar@st.com>	 <1267592861-26911-2-git-send-email-viresh.kumar@st.com>	 <1267592861-26911-3-git-send-email-viresh.kumar@st.com>	 <1267592861-26911-4-git-send-email-viresh.kumar@st.com>	 <1267592861-26911-5-git-send-email-viresh.kumar@st.com>	 <63386a3d1003092140o67a6c943rdee3a6c905cea7ef@mail.gmail.com>	 <4B973CF6.4030009@st.com>	 <63386a3d1003100131v7027e44cu5031c9ee3bf6ec73@mail.gmail.com>	 <4B977067.3050108@st.com> <63386a3d1003102243w637a8ce1m838a2dba946add32@mail.gmail.com>
In-Reply-To: <63386a3d1003102243w637a8ce1m838a2dba946add32@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linus,

On 3/11/2010 12:13 PM, Linus Walleij wrote:
> 2010/3/10 Viresh KUMAR <viresh.kumar@st.com>:
> 
>> One timer (or two channels) are used by clock event and clock source, but rest of
>> the timers are still available. So we need some way to export this functionality
>> of our hardware. It can be considered simply as a driver for GPT.
> 
> The timer people have already explained well enough I think, we have some 16
> timers on U8500, one we use as clocksource, one for clock events and 14 are
> currently unused. I plan to add them as clock events as soon as there is some
> practical use for them.
> I think there is nothing stopping you from modelling some extra clock events
> for the remaining timers if you absolutely want to, the kernel will
> just disregard
> them currently, which is just as good/bad as the way you're exposing the custom
> API in these patches.

Can we use clockevents directly? I though they are abstracted by the kernel
framework and using them directly is not advisable/feasible.

regards
Shiraz
