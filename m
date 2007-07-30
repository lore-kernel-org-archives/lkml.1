Return-Path: <linux-kernel-owner+w=401wt.eu-S935745AbXG3QJo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935745AbXG3QJo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 12:09:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759329AbXG3QJe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 12:09:34 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:16240 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756726AbXG3QJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 12:09:33 -0400
Subject: Re: v2.6.23-rc1-rt6-dw1
From: Daniel Walker <dwalker@mvista.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
In-Reply-To: <1185772831.2686.6.camel@laptopd505.fenrus.org>
References: <1185765740.2636.2.camel@imap.mvista.com>
	 <1185772831.2686.6.camel@laptopd505.fenrus.org>
Content-Type: text/plain
Date: Mon, 30 Jul 2007 08:59:14 -0700
Message-Id: <1185811154.2636.29.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-1.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-07-29 at 22:20 -0700, Arjan van de Ven wrote:
> >  
> > +/*
> > + * trigger a reschedule on all other CPUs:
> > + */
> > +extern void smp_send_reschedule_allbutself(void);
> > +
> > +/*
> > + * trigger a reschedule on all other CPUs:
> > + */
> > +extern void smp_send_reschedule_allbutself(void);
> > +
> 
> just to make sure the C compiler doesn't forget it ?
> or maybe the parser is suffering from memory lapse ? ;)

In terms of this whole patch, I should have been a little clearer about
it's meaning .. It represents code getting moved inside the -rt series..
For example the code above was originally in the,
preempt-realtime-core.patch and I moved it to the
preempt-realtime-i386.patch.

So I'm not actually adding any code.. I wasn't trying to put Ingo's code
up for evaluation either, since it's all still in development ..

Daniel

