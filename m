Return-Path: <linux-kernel-owner+w=401wt.eu-S1757455AbXJOVdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757455AbXJOVdP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 17:33:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754632AbXJOVc7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 17:32:59 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:43978 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754477AbXJOVc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 17:32:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=S1gdnbF0yAJ8LQCeJEUVGhF/Wh7ndYBwe3e2A3rgunXbXStshQc7Dk2PYYTsFXNhdjZj7PYACrBntPJe4h9veaAbbe/2CQuXJev5Zqbeogu5slnmE2KWj/lUNZCqDGXyXgsmAc3QMyxWZpJjoUPz0neiT6gkdSHuL18o2Wyn6E4=
Message-ID: <3ae72650710151432rb5b9c6fob95ee1c40733a685@mail.gmail.com>
Date: Mon, 15 Oct 2007 23:32:58 +0200
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: [RFC][PATCH] sched: SCHED_FIFO watchdog timer
Cc: linux-kernel <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Mike Galbraith" <efault@gmx.de>,
       "Lennart Poettering" <mztabzr@0pointer.de>
In-Reply-To: <1192315867.5625.6.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1192222309.5897.3.camel@lappy> <1192315867.5625.6.camel@lappy>
X-Google-Sender-Auth: 3256a35371e3627f
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/07, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> The below patch is an idea proposed by tglx and depends on sched-devel +
> the hrtick patch previously posted.
>
> The current watchdog action is to demote the task to SCHED_NORMAL,
> however it might be wanted to deliver a signal instead (or have more per
> task configuration state). Which is why I added Lennart to the CC list
> as I gathered he would like something like this for PulseAudio.

Great, this looks very promising. Thanks for doing this.

Kay
