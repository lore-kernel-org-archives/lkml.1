Return-Path: <linux-kernel-owner+w=401wt.eu-S1760761AbYETHTc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760761AbYETHTc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 03:19:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754910AbYETHTZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 03:19:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49293 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754462AbYETHTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 03:19:24 -0400
Date: Tue, 20 May 2008 00:17:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Brownell <david-b@pacbell.net>
Cc: Pavel Machek <pavel@ucw.cz>, lkml <linux-kernel@vger.kernel.org>,
       Trent Piepho <tpiepho@freescale.com>,
       hartleys <hartleys@visionengravers.com>,
       Ben Nizette <bn@niasdigital.com>, Mike Frysinger <vapier.adi@gmail.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: Re: [patch 2.6.26-rc2-git] gpio: sysfs interface
Message-Id: <20080520001727.b4fe8098.akpm@linux-foundation.org>
In-Reply-To: <200805171736.56340.david-b@pacbell.net>
References: <200804281239.51729.david-b@pacbell.net>
	<20080502203637.GG3956@ucw.cz>
	<200805171514.07619.david-b@pacbell.net>
	<200805171736.56340.david-b@pacbell.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 May 2008 17:36:55 -0700 David Brownell <david-b@pacbell.net> wrote:

> +static const struct attribute *gpiochip_attrs[] = {
> +	&dev_attr_base.attr,
> +	&dev_attr_label.attr,
> +	&dev_attr_ngpio.attr,
> +	NULL,
> +};
> +
> +static const struct attribute_group gpiochip_attr_group = {
> +	.attrs = (struct attribute **) gpiochip_attrs,
> +};

ick.  So we got caught partway through constification and we need to
patch it up with a cast.
