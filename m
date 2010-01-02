Return-Path: <linux-kernel-owner+w=401wt.eu-S1751815Ab0ABTdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751815Ab0ABTdt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 14:33:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751446Ab0ABTdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 14:33:49 -0500
Received: from casper.infradead.org ([85.118.1.10]:36097 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212Ab0ABTds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 14:33:48 -0500
Date: Sat, 2 Jan 2010 11:36:15 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: tglx@linutronix.de, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] timer: Introduce mod_timer_msec()
Message-ID: <20100102113615.10610cc5@infradead.org>
In-Reply-To: <20100102193013.GA2232@core.coreip.homeip.net>
References: <20100102104853.28505e39@infradead.org>
	<20100102105012.40d678f2@infradead.org>
	<877hs0724u.fsf@basil.nowhere.org>
	<20100102112108.574396fd@infradead.org>
	<20100102193013.GA2232@core.coreip.homeip.net>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2 Jan 2010 11:30:13 -0800
Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:

 timer returns 1.)
> > + */
> > +int mod_timer_msec(struct timer_list *timer, unsigned long delay_ms) 
> >+{
> > +	return mod_timer(timer, jiffies + msecs_to_jiffies(delay_ms)); 
> > +}
> > +EXPORT_SYMBOL(mod_timer_msec);
> 
> I wonder why isn't this an inline function? Seems tiny enough...

the next step I want to do is to add some more smarts here, around rounding/grouping etc;
it'll take some more infrastructure work in the timer system first, but if I'd
made this inline now I'd just have to uninline it a bit later...

> Other than that -  I'll gladly take input conversion patches.

great!



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

