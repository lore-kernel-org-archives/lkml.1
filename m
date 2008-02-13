Return-Path: <linux-kernel-owner+w=401wt.eu-S1761470AbYBMUSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761470AbYBMUSc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 15:18:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754816AbYBMUSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 15:18:24 -0500
Received: from wx-out-0506.google.com ([66.249.82.227]:7814 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754382AbYBMUSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 15:18:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=FhdKJcSefUEPmuO01RN1NNLvoVV3Aja/beeuWdH8aYKDs09uxvJs0J0nEyyqR/V6le07i58gJXHq/eesrbfzxTSkbcqH1C/UqkR24pdmFYNGs7W79FntIx7ZBjWl9hvKqb9YxxPIN65K9qQTLjM/fgc8Y9+Vl35/6moR0skIF9U=
Message-ID: <c4e36d110802131218i7bcc873bub5c8df96192b9563@mail.gmail.com>
Date: Wed, 13 Feb 2008 21:18:21 +0100
From: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
To: "Jiri Kosina" <jkosina@suse.cz>
Subject: Re: print_vma_addr possible deadlock (was Re: Jeste jeden bug)
Cc: "Ingo Molnar" <mingo@elte.hu>, "Andi Kleen" <ak@suse.de>,
       "Thomas Gleixner" <tglx@linutronix.de>, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0802132039240.30955@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c4e36d110802130841l591f20a4j32759821543b554c@mail.gmail.com>
	 <Pine.LNX.4.64.0802131749460.30955@jikos.suse.cz>
	 <Pine.LNX.4.64.0802131757360.7699@twin.jikos.cz>
	 <20080213193538.GA16402@elte.hu>
	 <Pine.LNX.4.64.0802132039240.30955@jikos.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/2/13, Jiri Kosina <jkosina@suse.cz>:
> On Wed, 13 Feb 2008, Ingo Molnar wrote:
>
> > The longer-term fix will be to not run int3 exception handlers in a
> > non-preemptible context (like 32-bit does) - but that will need more
> > testing.
>
> Yup, exactly.
>
> > Jiri Kosina reported the following deadlock scenario with
> > show_unhandled_signals enabled:
>
> Actually the kernel error message was reported to me by Zdenek. Zdenek,
> could you please try the fix?


Ok - great I do not get this BUG log
So this has fixed 2 problems a 3 other remains :)

I'll open them tomorrow I guess :) at my two were fixed pretty quickly.

PS: Ingo did you have a chance to check my kernel IPI problem ?

Zdenek
