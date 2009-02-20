Return-Path: <linux-kernel-owner+w=401wt.eu-S1756272AbZBTW3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756272AbZBTW3x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 17:29:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754525AbZBTW3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 17:29:21 -0500
Received: from ns1.siteground211.com ([209.62.36.12]:33451 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754262AbZBTW3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 17:29:19 -0500
Date: Sat, 21 Feb 2009 00:29:12 +0200
From: Felipe Balbi <me@felipebalbi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Felipe Balbi <me@felipebalbi.com>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org, dmitry.torokhov@gmail.com,
       felipe.balbi@nokia.com
Subject: Re: [PATCH] input: keyboard: introduce lm8323 driver
Message-ID: <20090220222911.GV32564@gandalf>
Reply-To: me@felipebalbi.com
References: <1235046677-29959-1-git-send-email-me@felipebalbi.com> <20090220141505.d1d53e4b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090220141505.d1d53e4b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 20, 2009 at 02:15:05PM -0800, Andrew Morton wrote:
> On Thu, 19 Feb 2009 14:31:17 +0200
> Felipe Balbi <me@felipebalbi.com> wrote:
> 
> > +struct lm8323_platform_data {
> > +	int debounce_time; /* Time to watch for key bouncing, in ms. */
> > +	int active_time; /* Idle time until sleep, in ms. */
> > +
> > +	int size_x;
> > +	int size_y;
> > +	int repeat : 1;
> 
> lm8323_platform_data.repeat appears to be never-written-to?

Nobody is using that yet, still it's used in the driver:
	if (pdata->repeat)
		__set_bit(EV_REP, idev->evbit);

Also, those spaces around : should vanish. Want me to resend the whole
patch or just a patch on top of it ?

-- 
balbi
