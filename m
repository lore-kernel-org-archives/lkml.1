Return-Path: <linux-kernel-owner+w=401wt.eu-S1753517AbXJ3CjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517AbXJ3CjX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 22:39:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752610AbXJ3CjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 22:39:16 -0400
Received: from ozlabs.org ([203.10.76.45]:41874 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752525AbXJ3CjP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 22:39:15 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] raise tsc clocksource rating
Date: Tue, 30 Oct 2007 13:39:23 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Glauber de Oliveira Costa <gcosta@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, --cc@redhat.com,
       Ingo Molnar <mingo@elte.hu>, avi@quramnet.com,
       kvm-devel@lists.sourceforge.net, John Stultz <johnstul@us.ibm.com>
References: <11936994092607-git-send-email-gcosta@redhat.com> <alpine.LFD.0.9999.0710292315280.3186@localhost.localdomain>
In-Reply-To: <alpine.LFD.0.9999.0710292315280.3186@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710301339.23628.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 October 2007 09:17:38 Thomas Gleixner wrote:
> On Mon, 29 Oct 2007, Glauber de Oliveira Costa wrote:
>
> CC'ed John and removed glauber@t60.localdomain :)
>
> > From: Glauber de Oliveira Costa <glauber@t60.localdomain>
> >
> > tsc is very good time source (when it does not have drifts, does not
> > change it's frequency, i.e. when it works), so it should have its rating
> > raised to a value greater than, or equal 400.
> >
> > Since it's being a tendency among paravirt clocksources to use values
> > around 400, we should declare tsc as even better: So we use 500.
> >
> > This patch also touches the comments on clocksource.h, which suggests
> > that 499 would be a limit on the rating values.
> >
> > Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
>
> Acked-by: Thomas Gleixner <tglx@linutronix.de>

No.  tsc is very good, it's not perfect.  If a paravirt clock registers 400 it 
really means "pick me over the tsc".

That's *why* they use > 400: it's in the documentation.

Rusty.
