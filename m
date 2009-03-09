Return-Path: <linux-kernel-owner+w=401wt.eu-S1753759AbZCIKfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759AbZCIKfV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 06:35:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753240AbZCIKfH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 06:35:07 -0400
Received: from mailbox-us-s-12.mailhostingserver.com ([75.125.101.9]:47480
	"EHLO mailbox-us-s-12.mailhostingserver.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751192AbZCIKfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 06:35:05 -0400
X-Greylist: delayed 443 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Mar 2009 06:35:05 EDT
Date: Mon, 9 Mar 2009 11:27:30 +0100
From: Matthias Kaehlcke <matthias@kaehlcke.net>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       Russell King <linux@arm.linux.org.uk>,
       Steven Rostedt <rostedt@rostedt.homelinux.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] ftrace: fix crash due to tracing of __naked functions
Message-ID: <20090309102730.GA32492@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias@kaehlcke.net>,
	Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@pengutronix.de>,
	linux-arm-kernel@lists.arm.linux.org.uk,
	linux-kernel@vger.kernel.org,
	Abhishek Sagar <sagar.abhishek@gmail.com>,
	Russell King <linux@arm.linux.org.uk>,
	Steven Rostedt <rostedt@home.goodmis.org>,
	Ingo Molnar <mingo@elte.hu>
References: <1236584800-7686-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1236584800-7686-1-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Mon, Mar 09, 2009 at 08:46:40AM +0100 Uwe Kleine-König ha dit:

> This is a fix for the following crash observed in 2.6.29-rc3:
> http://lkml.org/lkml/2009/1/29/150
> 
> On ARM it doesn't make sense to trace a naked function because then
> mcount is called without stack and frame pointer being set up and there
> is no chance to restore the lr register to the value before mcount was
> called.
> 
> Compared to the original fix posted to arm-linux-kernel ML on 29 Jan
> 2009 by Abhishek Sagar I only changed the definition of __naked for ARM.
> 
> Reported-by: Matthias Kaehlcke <matthias@kaehlcke.net>
> Cc: Abhishek Sagar <sagar.abhishek@gmail.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Steven Rostedt <rostedt@home.goodmis.org>
> Cc: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
> Hello,
> 
> without this change a kernel having CONFIG_FUNCTION_TRACER=y doesn't
> boot on many maschines.  It would be great if this change would make it
> into .29.

i agree that it would be convenient to have this resolved in .29

Tested-by: Matthias Kaehlcke <matthias@kaehlcke.net>

-- 
Matthias Kaehlcke
Embedded Linux Engineer
Barcelona


  The salvation of mankind lies only in making everything the concern of all
                         (Alexander Solzhenitsyn)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
