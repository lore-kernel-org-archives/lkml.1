Return-Path: <linux-kernel-owner+w=401wt.eu-S1758277AbXESDen@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758277AbXESDen (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 23:34:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754761AbXESDeg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 23:34:36 -0400
Received: from ozlabs.org ([203.10.76.45]:52031 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754561AbXESDeg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 23:34:36 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17998.28659.702653.237011@cargo.ozlabs.ibm.com>
Date: Sat, 19 May 2007 13:33:07 +1000
From: Paul Mackerras <paulus@samba.org>
To: Daniel Walker <dwalker@mvista.com>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>, linuxppc-dev@ozlabs.org,
       tglx@linutronix.de, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.21-rt2] PowerPC: decrementer clockevent driver
In-Reply-To: <1179502773.20519.56.camel@imap.mvista.com>
References: <200705172142.26739.sshtylyov@ru.mvista.com>
	<8E44DB06-767D-4864-8D2C-6132E4D4370B@kernel.crashing.org>
	<464C99FF.8080404@ru.mvista.com>
	<135307ED-7125-4859-8594-4B5B900D92D6@kernel.crashing.org>
	<1179500217.20519.53.camel@imap.mvista.com>
	<464DC0DC.7050809@ru.mvista.com>
	<1179502773.20519.56.camel@imap.mvista.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Walker writes:

> On Fri, 2007-05-18 at 19:06 +0400, Sergei Shtylyov wrote:
> >     Well, the decrementer frequency may change, at least in theory (if the bus 
> > clock changes).
> 
> Does that happen very often?

If it did, gettimeofday would start reporting seriously wrong values,
since the timebase and the decrementer count at the same rate, and we
don't have any provision for fixing things up if that rate changed.
Fortunately there are no powerpc platforms where the rate is
variable.

Paul.
