Return-Path: <linux-kernel-owner+w=401wt.eu-S1750901AbZKEFGL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750901AbZKEFGL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 00:06:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750807AbZKEFGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 00:06:10 -0500
Received: from mail-iw0-f180.google.com ([209.85.223.180]:50806 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787AbZKEFGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 00:06:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=WRAWgPKYLLKfnIx4MIGKf7KIsNCd4sz36BP08EY58xbQQXopa5vEnM9bT6uLTokGvm
         kSirjXIOrehDniJ2ny670JpSzM6l3U82VU8hnEqLc8CoUVG94gSzsrmB/7+UFa+Jpo0k
         WRJQPUYiczLPUX4hEilKyTcGhqh340DAIZ36c=
MIME-Version: 1.0
In-Reply-To: <1257241821.4269.5.camel@utx.utx.cz>
References: <20091031013427.GL14091@buzzloop.caiaq.de>
	 <20091101205449.GT14091@buzzloop.caiaq.de>
	 <20091101213343.GA31345@elf.ucw.cz>
	 <20091101220341.GA16698@elf.ucw.cz>
	 <771cded00911020122o3bb5cc96q957c8be1ce7cae46@mail.gmail.com>
	 <1257155873.5642.14.camel@utx.utx.cz>
	 <771cded00911021931x41cfa51bh2959d3748db5ac0@mail.gmail.com>
	 <1257241821.4269.5.camel@utx.utx.cz>
Date: Thu, 5 Nov 2009 00:06:13 -0500
Message-ID: <771cded00911042106u39fd3655mae50a89bd419411b@mail.gmail.com>
Subject: Re: Possible suspend/resume regression in .32-rc?
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Stanislav Brabec <utx@penguin.cz>
Cc: Pavel Machek <pavel@ucw.cz>, dsaxena@laptop.org, alan@linux.intel.com,
       gregkh@suse.de, Daniel Mack <daniel@caiaq.de>,
       linux-arm-kernel@lists.infradead.org, Eric <eric.y.miao@gmail.com>,
       Haojian Zhuang <haojian.zhuang@marvell.com>, rpurdie@rpsys.net,
       lenz@cs.wisc.edu, kernel list <linux-kernel@vger.kernel.org>,
       Dirk@opfer-online.de, arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>,
       thommycheck@gmail.com, dbaryshkov@gmail.com, omegamoon@gmail.com,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 3, 2009 at 4:50 AM, Stanislav Brabec <utx@penguin.cz> wrote:
> Haojian Zhuang wrote:
>> On Mon, Nov 2, 2009 at 5:57 AM, Stanislav Brabec <utx@penguin.cz> wrote:
>> > Haojian Zhuang wrote:
>> >
>> >> Commit b5b82df6, from May 2007, breaks no_console_suspend on the OLPC
>> >> XO laptop. Basically what happens is that upon returning from resume,
>> >> serial8250_resume_port() will reconfigure the port for high speed
>> >> mode and all console output will be garbled, making debug of the
>> >> resume path painful. This patch modifies uart_resume_port() to
>> >> reset the port to the state it was in before we suspended.
>> >
>> > See my patch waiting for approval in LKML thread
>> > "serial-core: resume serial hardware with no_console_suspend".
>> >
>> > It attempts to fix it, but I was not yet able to test it due to spitz
>> > resume breakage.
>> >
>>
>> Hi Stanislav,
>>
>> At first, your patch can't be applied into my latest codebase. I have
>> to update the patch. But the console resume is still blocked after
>> applied your patch. It works only after I merge some old code back. My
>> modified patch is in below.
>
> Yes, code changed there a bit. I sent rebased patch later in the thread.
> Did you try this one? (Well I did not test it yet - in time of sending
> resume did not work at all on my Zaurus.)
>
> Your patch is a bit different. I'll test both as soon as possible.
>
>

Your latest patch works well in my platform. Thanks a lot.
