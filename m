Return-Path: <linux-kernel-owner+w=401wt.eu-S1759007AbZCOGe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759007AbZCOGe4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 02:34:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752044AbZCOGer
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 02:34:47 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35211 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012AbZCOGeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 02:34:46 -0400
Date: Sun, 15 Mar 2009 07:34:38 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Tim Bird <tim.bird@am.sony.com>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       Russell King <linux@arm.linux.org.uk>,
       Steven Rostedt <rostedt@rostedt.homelinux.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] ftrace: fix crash due to tracing of __naked functions
Message-ID: <20090315063438.GA6982@pengutronix.de>
References: <1236584800-7686-1-git-send-email-u.kleine-koenig@pengutronix.de> <49BC5D8C.209@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49BC5D8C.209@am.sony.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tim,

On Sat, Mar 14, 2009 at 06:44:44PM -0700, Tim Bird wrote:
> Uwe Kleine-König wrote:
> > without this change a kernel having CONFIG_FUNCTION_TRACER=y doesn't
> > boot on many maschines.  It would be great if this change would make it
> > into .29.
> 
> I'd like to ACK this patch (not sure if my opinion matters).
It doesn't matter, but only because the patch is already on its way to
Linus.  :-)  Russell took the patch and sent a pull request.  It didn't
hit Linus tree yet, though.

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
