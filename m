Return-Path: <linux-kernel-owner+w=401wt.eu-S1756395AbZLLDp7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756395AbZLLDp7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 22:45:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751131AbZLLDp6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 22:45:58 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:64773 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbZLLDp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 22:45:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=nTr2pfOtXD6uOX3mIxssHq9uZT8L8F08ZXDyc+Ob8JuXoBDy/Jve0U5DO3ln7S1b3G
         VGjVig1R2kHPJ2ZthyLstA/fQyiMylH7aYVLV2U6dwIEkUIUtbI4uMZZ18YrT0DdTP/n
         X0CGyAVReRdg+NDY8dKGLMT4qhXhFuFDSYhf8=
MIME-Version: 1.0
In-Reply-To: <20091211102159.GB18825@rakim.wolfsonmicro.main>
References: <f9f38a550912090647q5af6cb14w84ea8d9223d82bd9@mail.gmail.com>
	 <20091209145919.GH9018@sirena.org.uk>
	 <f9f38a550912110027r70710867k3a08c6d5913ce13@mail.gmail.com>
	 <20091211102159.GB18825@rakim.wolfsonmicro.main>
Date: Sat, 12 Dec 2009 11:46:04 +0800
Message-ID: <f9f38a550912111946w665b267dkc42d184bdc437d02@mail.gmail.com>
Subject: Re: Questions about Watch Dog Timer under Linux.
From: Cypher Wu <cypher.w@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 11, 2009 at 6:21 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Fri, Dec 11, 2009 at 04:27:55PM +0800, Cypher Wu wrote:
>
> Please reply in-line to e-mails, it makes the conversation much easier
> to follow.
>
>> It seems WATCHDOG_NOWAYOUT is a software mechanism? If it is defined
>> as 1 then the WDT can't be stopped if it has been started whether bye
>> closing the device file or writing the magic character 'V'.
>
> Yes, it's a kernel build time configurable option to select this
> behaviour.  In effect all you'd be doing is making a driver which turns
> it on all the time.
>

My point is not making a driver which turns WDT on all the time, but
how to work with a WDT hardware which will startup to working just
after power on and the only interface it provides is clearing the
timer. This type of WDT is widely used in our embedded systems and we
usually install a callback in timer interrupt to clearing WD before
BSP starting the RTOS kernel, and then starting a task to clear WD and
uninstall the callback.
I'm wonder when cope with that type of WD, is there any framework
already in the Linux kernel and booter, or I've to modify them by
myself?
