Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754276Ab0BVSMA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 13:12:00 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:64614 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838Ab0BVSLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 13:11:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=pvaQs/QAFgZCyH2gLzr/5i9N4lU8GyGsTYsntluN3VhetclPf4FJuTBlZzvOsMjdXT
         JNxnF2wAYrk+T3wcCo8Mcc48jktikk+EpWSozzXI7fbiJ9gRoWajjmL0oJHAhUEXsNt6
         3E2df8r+/JFzX9rl4nieQidStAA2yGsmY3bVQ=
Date: Mon, 22 Feb 2010 23:36:24 +0530
From: Rabin Vincent <rabin@rab.in>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>
Subject: Re: [PATCH 02/10] ARM: ftrace: document mcount formats
Message-ID: <20100222180624.GA4061@debian>
References: <1266090518-31120-1-git-send-email-rabin@rab.in>
 <1266090518-31120-3-git-send-email-rabin@rab.in>
 <20100213203748.GC16528@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100213203748.GC16528@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 13, 2010 at 09:37:48PM +0100, Uwe Kleine-König wrote:
> On Sun, Feb 14, 2010 at 01:18:30AM +0530, Rabin Vincent wrote:
> > + * With both the mcount types, we need to restore the original lr before
> > + * returning.  In the __gnu_mcount_nc, version we're allowed to clobber ip.
> > + * No other registers should be clobbered.
> > + */
> Very nice.
> 
> Maybe make the last two sentences:
> 
> In the __gnu_mcount_nc case the ip register is clobbered which is OK as
> the calling convention for ARM allow clobbering this value for
> subroutines and it doesn't contain parameters.

Won't quoting calling conventions here be misleading?  The mcounts don't
following normal convention for the other bits (we can't clobber even
the registers that are normally caller-saved, we need to restore lr,
etc.)

Rabin
