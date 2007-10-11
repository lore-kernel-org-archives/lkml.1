Return-Path: <linux-kernel-owner+w=401wt.eu-S1758548AbXJKTPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758548AbXJKTPo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 15:15:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754539AbXJKTPh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 15:15:37 -0400
Received: from rv-out-0910.google.com ([209.85.198.184]:7711 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754018AbXJKTPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 15:15:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rtqVMswL8D+tBvKPC9ETm5auqV7ZDETL2UmNjp1iupcw5od76PM4bx2APMf7gdqr1jXhiOVl1NuMkW3GXmkV3/biNphXLYIPrH9f4D401YFWvCa1knZIaLnpqnpQDDZv+Xe4glFaShYdRAmdFpYpZW4PMyMyZ70dTsYYoqK4yhk=
Message-ID: <19f34abd0710111215w7137c104p8205d562589f456b@mail.gmail.com>
Date: Thu, 11 Oct 2007 21:15:35 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Johannes Weiner" <hannes-kernel@saeurebad.de>
Subject: Re: [PATCH] init: Fix printk format strings
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20071011172121.GC28048@saeurebad.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1192083422.26648.19.camel@grianne>
	 <20071011172121.GC28048@saeurebad.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/07, Johannes Weiner <hannes-kernel@saeurebad.de> wrote:
> On Thu, Oct 11, 2007 at 08:17:02AM +0200, Vegard Nossum wrote:
> > This makes sure printk format strings are string literals containing no
> > more than a single line.
>
> Perhaps you should write _why_ one-line printk()s are even needed, with
> profound reasons instead of constantly talking about mysterious later changes
> that you will propose any time soon.

In short, the reason for disallowing multiple lines per call is that
printk() will be less complex, while not really changing the
complexity of the callers (a change in the code, yes, but the changes
are trivial, and, actually, not that many).

I think I see now, though, that my changes will not gain support if I
do not lift this restriction.

You can find my current "mysterious later changes" as patches, with
descriptions, at this address: http://folk.uio.no/vegardno/xprintf/

Thanks for the tip, though. I am quite new to the kernel business, so
bear with me :)

Kind regards,
Vegard Nossum
