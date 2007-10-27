Return-Path: <linux-kernel-owner+w=401wt.eu-S1754197AbXJ0KMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197AbXJ0KMy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 06:12:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751425AbXJ0KMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 06:12:46 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:35490 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbXJ0KMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 06:12:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CC780nZn5hIqiPb979TRH/KwmzsJOAhInhDhrSX3tZxSRVq53zYjBAFdma6tM+mT3iXZfyosMyOqpDehGY3fOxG8oTuiAAuwtJrNuo/S2kAnVqAkMB8v8HEKIjX7+qTYhUBQzXV8mfdTwm3xeIcgIcVBaK7Goq7ByjZS+olRlcc=
Message-ID: <3f9a31f40710270312o5a4eb79exa67ed63b4f084f9e@mail.gmail.com>
Date: Sat, 27 Oct 2007 15:42:32 +0530
From: "Jaswinder Singh" <jaswinderlinux@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [2.6.23-rt3] NMI watchdog trace of deadlock
Cc: "Nick Piggin" <nickpiggin@yahoo.com.au>, "Mike Galbraith" <efault@gmx.de>,
       "Steven Rostedt" <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <20071027094407.GA12047@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1193245634.20679.8.camel@localhost.localdomain>
	 <1193462494.25330.7.camel@Homer.simpson.net>
	 <200710271915.42363.nickpiggin@yahoo.com.au>
	 <20071027094407.GA12047@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ingo,

On 10/27/07, Ingo Molnar <mingo@elte.hu> wrote:
>
> it's not atomic interrupt context but irq thread context - and -rt
> remaps kmap_atomic() to kmap() internally.
>
> the problem seems to be what Mike's patch works around: fiddling with
> irq flags in the ntfs code. That fiddling seems quite unnecessary at
> first sight.
>

Is this a nice idea to go inside device drivers and filesystem and
make changes in kernel source code to enable RT.

RT related change should be in header files, so that we don't need to
make changes for drivers or filesystem source files.

And when user will disable RT then these patches will again make problems.

We need to find some better alternative.

Thank you,

Jaswinder Singh.
