Return-Path: <linux-kernel-owner+w=401wt.eu-S932435AbXAVT5M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932435AbXAVT5M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 14:57:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932416AbXAVT4w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 14:56:52 -0500
Received: from smtp.osdl.org ([65.172.181.24]:45513 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751970AbXAVT4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 14:56:50 -0500
Date: Mon, 22 Jan 2007 11:56:24 -0800
From: Andrew Morton <akpm@osdl.org>
To: Ben Dooks <ben@trinity.fluff.org>
Cc: rpurdie@rpsys.net, ben-linux@fluff.org, linux-kernel@vger.kernel.org
Subject: Re: LEDS: S3C24XX generate name if none given
Message-Id: <20070122115624.2aefb97c.akpm@osdl.org>
In-Reply-To: <20070115154221.GH11889@trinity.fluff.org>
References: <20070115122654.GA25047@home.fluff.org>
	<1168868669.5860.49.camel@localhost.localdomain>
	<20070115154221.GH11889@trinity.fluff.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 15 Jan 2007 15:42:21 +0000 Ben Dooks <ben@trinity.fluff.org> wrote:
> On Mon, Jan 15, 2007 at 01:44:28PM +0000, Richard Purdie wrote:
> > On Mon, 2007-01-15 at 12:26 +0000, Ben Dooks wrote:
> > > Generate a name if none is passed to the S3C24XX GPIO LED driver.

Wouldn't it be better to fix the callers to consistently pass in a name
rather than hacking around fixing stuff up in the callee?

> +	/* create name if we were not passed one */
> +
> +	if (led->cdev.name == NULL) {
> +		char name[64];
> +
> +		snprintf(name, sizeof(name), "%s.%d",  dev->name, dev->id);
> +		led->cdev.name = kstrdup(name);
> +	}
> +

Take a peek at kasprintf() ;)

Please include full-and-fresh changelog in each iteration of a patch, so
poor patch-takers don't have to go making one up for you, thanks.
