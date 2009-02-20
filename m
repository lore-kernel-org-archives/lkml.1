Return-Path: <linux-kernel-owner+w=401wt.eu-S1756124AbZBTWzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124AbZBTWzf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 17:55:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754515AbZBTWzL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 17:55:11 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40045 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752773AbZBTWzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 17:55:09 -0500
Date: Fri, 20 Feb 2009 14:54:12 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: me@felipebalbi.com
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       dmitry.torokhov@gmail.com, felipe.balbi@nokia.com
Subject: Re: [PATCH] input: keyboard: introduce lm8323 driver
Message-Id: <20090220145412.742feb9c.akpm@linux-foundation.org>
In-Reply-To: <20090220222911.GV32564@gandalf>
References: <1235046677-29959-1-git-send-email-me@felipebalbi.com>
	<20090220141505.d1d53e4b.akpm@linux-foundation.org>
	<20090220222911.GV32564@gandalf>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Feb 2009 00:29:12 +0200
Felipe Balbi <me@felipebalbi.com> wrote:

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

Yes, but that's presently dead code.

> Also, those spaces around : should vanish. Want me to resend the whole
> patch or just a patch on top of it ?

I already fixed that.
