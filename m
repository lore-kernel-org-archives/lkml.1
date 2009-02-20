Return-Path: <linux-kernel-owner+w=401wt.eu-S1755382AbZBTWxG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382AbZBTWxG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 17:53:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754017AbZBTWwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 17:52:55 -0500
Received: from ns1.siteground211.com ([209.62.36.12]:38314 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441AbZBTWwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 17:52:54 -0500
Date: Sat, 21 Feb 2009 00:52:48 +0200
From: Felipe Balbi <me@felipebalbi.com>
To: Felipe Balbi <me@felipebalbi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org, dmitry.torokhov@gmail.com,
       felipe.balbi@nokia.com
Subject: Re: [PATCH] input: keyboard: introduce lm8323 driver
Message-ID: <20090220225247.GY32564@gandalf>
Reply-To: me@felipebalbi.com
References: <1235046677-29959-1-git-send-email-me@felipebalbi.com> <20090220141505.d1d53e4b.akpm@linux-foundation.org> <20090220222911.GV32564@gandalf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090220222911.GV32564@gandalf>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 21, 2009 at 12:29:12AM +0200, Felipe Balbi wrote:
> On Fri, Feb 20, 2009 at 02:15:05PM -0800, Andrew Morton wrote:
> > On Thu, 19 Feb 2009 14:31:17 +0200
> > Felipe Balbi <me@felipebalbi.com> wrote:
> > 
> > > +struct lm8323_platform_data {
> > > +	int debounce_time; /* Time to watch for key bouncing, in ms. */
> > > +	int active_time; /* Idle time until sleep, in ms. */
> > > +
> > > +	int size_x;
> > > +	int size_y;
> > > +	int repeat : 1;
> > 
> > lm8323_platform_data.repeat appears to be never-written-to?
> 
> Nobody is using that yet, still it's used in the driver:
> 	if (pdata->repeat)
> 		__set_bit(EV_REP, idev->evbit);
> 
> Also, those spaces around : should vanish. Want me to resend the whole
> patch or just a patch on top of it ?

well, I'm stopping for today (almost 1am), here's an update patch. If
you need me to resend the patch, I can do it when I wake up, just bug me
;-)

diff --git a/include/linux/i2c/lm8323.h b/include/linux/i2c/lm8323.h
index 37f819b..67e82bc 100644
--- a/include/linux/i2c/lm8323.h
+++ b/include/linux/i2c/lm8323.h
@@ -33,7 +33,7 @@ struct lm8323_platform_data {
 
        int size_x;
        int size_y;
-       int repeat : 1;
+       int repeat:1;
        const s16 *keymap;
 
        char *pwm1_name; /* Device name for PWM1. */

-- 
balbi
