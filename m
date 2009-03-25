Return-Path: <linux-kernel-owner+w=401wt.eu-S1756483AbZCYRFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756483AbZCYRFy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 13:05:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752420AbZCYRFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 13:05:46 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57716 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbZCYRFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 13:05:45 -0400
Date: Wed, 25 Mar 2009 18:05:33 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Tim Bird <tim.bird@am.sony.com>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: Anyone working on ftrace function graph support on ARM?
Message-ID: <20090325170533.GA4667@pengutronix.de>
References: <49C936CA.8070800@am.sony.com> <20090324213618.GC5975@nowhere> <49C95EAF.7030901@gmail.com> <20090324224857.GE5975@nowhere> <20090325084248.GF4697@n2100.arm.linux.org.uk> <49CA5CFF.8090908@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49CA5CFF.8090908@am.sony.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 25, 2009 at 09:34:07AM -0700, Tim Bird wrote:
> Russell King - ARM Linux wrote:
> > As pointed out in my previous mail, identifying where on the stack the
> > return address is stored is only possible for OABI with frame pointers.
> > 
> > EABI will probably be possible with the stack unwinding code, but it
> > probably won't be cheap.  The EABI unwinder is scheduled for merging
> > during the present now-open merge window.
EABI with frame pointers should work, too, shouldn't it?

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
