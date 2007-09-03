Return-Path: <linux-kernel-owner+w=401wt.eu-S1754646AbXICMeY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646AbXICMeY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 08:34:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752586AbXICMeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 08:34:16 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:23791 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316AbXICMeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 08:34:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=W4awMl+f8fJ//h4Jnrj9fpWkAcD7UGLMLxPh56WDCbHm7XVXt/RWEbDzUUdH/vVn4BQzWEhXkB/J84bAeza9n1TCTWO+h+ECdDW6ycJ3LTPQflrXdRhy3e3gQXdW0Jkp1rVWEjk7FwZnJa7Bfsd8fFSfKYm6BxqcoMPLY2J4/lE=
Message-ID: <b6a2187b0709030534t6589772ahb1f8e45490a7b00d@mail.gmail.com>
Date: Mon, 3 Sep 2007 20:34:09 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Pavel Machek" <pavel@ucw.cz>
Subject: Re: highres timers break cpu hotplug in 2.6.23-rc5 [was Re: cpu hotplug support broken in 2.6.23-rc3]
Cc: rusty@rustycorp.com.au, vatsa@in.ibm.com, zwane@arm.linux.org.uk,
       "kernel list" <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, tglx@linutronix.de
In-Reply-To: <20070903035644.GC3655@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070827104350.GA2073@elf.ucw.cz>
	 <20070827105801.GA4053@elf.ucw.cz>
	 <b6a2187b0708270736q5cfc180fp3c223a57ea6904f9@mail.gmail.com>
	 <20070827213248.GF3398@elf.ucw.cz>
	 <b6a2187b0708280721w20d5dc44q249642f7946ae55a@mail.gmail.com>
	 <20070903035644.GC3655@ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/3/07, Pavel Machek <pavel@ucw.cz> wrote:

> It gets weirder. With "nohz=off" on commandline, I have to press any
> key (generate interrupt?) for echo 1  > online to finish. 2.6.23-rc5
> kernel... but hotplug/unplug works reliably now.
>
> With nohz=off highres=off I can unplug/replug cpus as much as I
> want... running in tight loop now.

Yes. CONFIG_NO_HZ and and CONFIG_HIGH_RES_TIMERS has to be unset or
suspend-to-disk would just hang, unless you type something on the
keyboard, and then you can suspend to disk. It seems interrupts are
not missing.

Thanks,
Jeff.
