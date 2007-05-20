Return-Path: <linux-kernel-owner+w=401wt.eu-S1761183AbXETV15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761183AbXETV15 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 17:27:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757688AbXETV1s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 17:27:48 -0400
Received: from gate.crashing.org ([63.228.1.57]:36064 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757024AbXETV1r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 17:27:47 -0400
Subject: Re: [PATCH 2.6.21-rt2] PowerPC: decrementer clockevent driver
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Segher Boessenkool <segher@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, Daniel Walker <dwalker@mvista.com>,
       linuxppc-dev@ozlabs.org, tglx@linutronix.de
In-Reply-To: <995a4a7a4cada5604be7b30dcce8eb81@kernel.crashing.org>
References: <200705172142.26739.sshtylyov@ru.mvista.com>
	 <8E44DB06-767D-4864-8D2C-6132E4D4370B@kernel.crashing.org>
	 <464C99FF.8080404@ru.mvista.com>
	 <135307ED-7125-4859-8594-4B5B900D92D6@kernel.crashing.org>
	 <1179500217.20519.53.camel@imap.mvista.com>
	 <464DC0DC.7050809@ru.mvista.com>
	 <1179502773.20519.56.camel@imap.mvista.com>
	 <17998.28659.702653.237011@cargo.ozlabs.ibm.com>
	 <1179628991.20925.2.camel@imap.mvista.com>
	 <1179630190.32247.534.camel@localhost.localdomain>
	 <995a4a7a4cada5604be7b30dcce8eb81@kernel.crashing.org>
Content-Type: text/plain
Date: Mon, 21 May 2007 07:26:54 +1000
Message-Id: <1179696414.32247.570.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-05-20 at 18:02 +0200, Segher Boessenkool wrote:
> > In fact, while it's never worded explicitely in the spec, it's always
> > been strongly in the "spirit" of the architecture that the timebase and
> > decrementer have a constant frequency.
> 
> The architecture mentions varying time base frequencies,
> and how to deal with this, actually.  It makes no
> recommendations one way or the other.

I might be mixing up with PAPR... anyway, it's very stupid to vary it
imho. And as I just said, I have about 0 plan to imlement support for
such a contraption.

> Fixed frequencies are easier for almost everything of
> course :-)

Yup.

> > This is why processors like the
> > 970 allow for an external sourcing for when they are used in setups
> > where the various clocks are slewed for power management.
> 
> Clock spreading on the core clock is the bigger problem,
> lack of accuracy on the order of 1% is unacceptable for
> certain applications.

That too.

Ben.


