Return-Path: <linux-kernel-owner+w=401wt.eu-S1760905AbZB0V2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760905AbZB0V2W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 16:28:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758066AbZB0V2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 16:28:13 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38374 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757624AbZB0V2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 16:28:12 -0500
Date: Fri, 27 Feb 2009 22:28:09 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Daniel Walker <dwalker@fifo99.com>
Cc: linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@rostedt.homelinux.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Don't profile branches in arm's boot decompressor
Message-ID: <20090227212809.GA5338@pengutronix.de>
References: <1235768983-4830-1-git-send-email-u.kleine-koenig@pengutronix.de> <1235769587.8233.1.camel@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1235769587.8233.1.camel@desktop>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On Fri, Feb 27, 2009 at 01:19:47PM -0800, Daniel Walker wrote:
> On Fri, 2009-02-27 at 22:09 +0100, Uwe Kleine-König wrote:
> > This fixes many compile errors for arch/arm/boot/compressed/misc.c of
> > the type:
> > 
> > 	arch/arm/boot/compressed/misc.c:127: error: section attribute cannot be specified for local variables
> 
> Why do you think this error showed up just in that one file? It looks
> like the branch tracer puts section tags on non-globals all over the
> kernel..
With this patch I was able to compile an ARM kernel with profiling
enabled.  Is that enough justification?

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
