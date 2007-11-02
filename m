Return-Path: <linux-kernel-owner+w=401wt.eu-S1760243AbXKBBvs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760243AbXKBBvs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 21:51:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755154AbXKBBvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 21:51:40 -0400
Received: from mxsf00.insightbb.com ([74.128.0.70]:9298 "EHLO
	mxsf00.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753802AbXKBBvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 21:51:40 -0400
X-IronPort-AV: E=Sophos;i="4.21,360,1188792000"; 
   d="scan'208";a="96376366"
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FADYfKkdKjlCP/2dsb2JhbACBWw
X-IronPort-AV: E=Sophos;i="4.21,360,1188792000"; 
   d="scan'208";a="90867158"
From: Dmitry Torokhov <dtor@insightbb.com>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: kernel processes - are they really needed?
Date: Thu, 1 Nov 2007 21:51:34 -0400
User-Agent: KMail/1.9.3
Cc: Ram <vshrirama@gmail.com>, linux-kernel@vger.kernel.org
References: <8bf247760710240637w686f1a2fxdf63a649787eca25@mail.gmail.com> <d120d5000710310935i13629beahdc01e775e3cf6aa@mail.gmail.com> <p73k5p32nqk.fsf@bingen.suse.de>
In-Reply-To: <p73k5p32nqk.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711012151.35573.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 31 October 2007 13:33, Andi Kleen wrote:
> "Dmitry Torokhov" <dmitry.torokhov@gmail.com> writes:
> 
> > On 10/24/07, Andi Kleen <andi@firstfloor.org> wrote:
> >>
> >> My favourite for a ridiculous thread was and is "kpsmoused"
> >>
> >
> > Mouse querying can take significant amount of time. Do you really want
> > all your other events to be delayed just because kernel tries to get
> > mouse back in order?
> 
> How long?

If a mouse is stubborn and does not want to get enabled it may sleep
up to 1 sec.

> 
> 
> >
> > Although I probably want to kill it if mouse resync is disabled...
> 
> How often does that happen? Can't you just start a thread for this
> as needed? Or if it's a simple algorithm you can just use a state machine
> using timers?
>

The IRQ handler is already too complex, I'd rather not mess with a state
machine. I will see how to kill the thread if resync is disabled.

-- 
Dmitry
