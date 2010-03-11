Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752350Ab0CKGnU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 01:43:20 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:58024 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002Ab0CKGnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 01:43:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=PPJFwg0UM/zFvq6YJlkXkchuNv7ixMG4CP6Vm1UtOTwU+SO3hn1ZklUS7+m7ibJFQ0
         C9NOoUMnBhocqbkPJKi9DF9WvcluWDsTqhAes+Di9MGkTr2Y4vpDhDiLex5LeYQA0H6v
         ALRsFc+jUyA0pgQti0iSm8x6+0/AjKjqw3qx0=
MIME-Version: 1.0
In-Reply-To: <4B977067.3050108@st.com>
References: <1267592861-26911-1-git-send-email-viresh.kumar@st.com>
	 <1267592861-26911-2-git-send-email-viresh.kumar@st.com>
	 <1267592861-26911-3-git-send-email-viresh.kumar@st.com>
	 <1267592861-26911-4-git-send-email-viresh.kumar@st.com>
	 <1267592861-26911-5-git-send-email-viresh.kumar@st.com>
	 <63386a3d1003092140o67a6c943rdee3a6c905cea7ef@mail.gmail.com>
	 <4B973CF6.4030009@st.com>
	 <63386a3d1003100131v7027e44cu5031c9ee3bf6ec73@mail.gmail.com>
	 <4B977067.3050108@st.com>
Date: Thu, 11 Mar 2010 07:43:16 +0100
Message-ID: <63386a3d1003102243w637a8ce1m838a2dba946add32@mail.gmail.com>
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

> One timer (or two channels) are used by clock event and clock source, but rest of
> the timers are still available. So we need some way to export this functionality
> of our hardware. It can be considered simply as a driver for GPT.

The timer people have already explained well enough I think, we have some 16
timers on U8500, one we use as clocksource, one for clock events and 14 are
currently unused. I plan to add them as clock events as soon as there is some
practical use for them.

I think there is nothing stopping you from modelling some extra clock events
for the remaining timers if you absolutely want to, the kernel will
just disregard
them currently, which is just as good/bad as the way you're exposing the custom
API in these patches.

Yours,
Linus Walleij
