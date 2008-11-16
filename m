Return-Path: <linux-kernel-owner+w=401wt.eu-S1754497AbYKPQG5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497AbYKPQG5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 11:06:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753156AbYKPQGq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 11:06:46 -0500
Received: from ti-out-0910.google.com ([209.85.142.185]:5527 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705AbYKPQGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 11:06:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=p5xXB4qOEPyWxQewJWaMIbEOGq0Ptliif29NkA0TkM5haiEqxvQWxqjzs54M6v1g1H
         n94rttJfnUJAkgX6i2GaXmcVkYZ/+JP5DQAfhO6UR6R7vSThATbtBTzraI+K7qveCs0V
         FhU2PvJMGQLSXdFXiBcy2yy/z1GYb4Tx7z0RU=
Date: Mon, 17 Nov 2008 00:06:38 +0800
From: walimis <walimisdev@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Fr??????ic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 1/1] ftrace: fix wrong pos computing when read buffer
	has been fulfilled.
Message-ID: <20081116160638.GA11415@ubuntu.mshome.net>
References: <1226733546-23190-1-git-send-email-walimisdev@gmail.com> <20081116073354.GF19646@elte.hu> <alpine.DEB.1.10.0811160959520.2919@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0811160959520.2919@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 16, 2008 at 10:01:46AM -0500, Steven Rostedt wrote:
>
>On Sun, 16 Nov 2008, Ingo Molnar wrote:
>> * walimis <walimisdev@gmail.com> wrote:
>> 
>> > hi Steven,
>> > 
>> > Could you help me to review this patch?
>> > 
>> > Thanks.
>> > 
>> > Impact: make output of available_filter_functions complete
>> > 
>> > phenomenon:
>> > 
>> > Signed-off-by: walimis <walimisdev@gmail.com>
>> > ---
>> >  kernel/trace/ftrace.c |   26 +++++++++++++++-----------
>> >  1 files changed, 15 insertions(+), 11 deletions(-)
>> 
>> looks sane - applied to tip/tracing/urgent. Steve, any objections?
>
>I'm actually still reviewing it. I was busy with the PPC work, so I did 
>not finish my review. Weekends are family time, so my activity now is 
>minimal. Pull it in, and if I find any problems with it, I'll just submit 
>a patch on top, or have walimis fix it ;-)
OK, thanks for your review.
If I find any problem, I will submit to you ASAP.

walimis
>
>-- Steve
