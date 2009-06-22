Return-Path: <linux-kernel-owner+w=401wt.eu-S1758158AbZFVT0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758158AbZFVT0b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 15:26:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753086AbZFVT0X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 15:26:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35966 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752344AbZFVT0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 15:26:23 -0400
Date: Mon, 22 Jun 2009 12:25:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jani Nikula <ext-jani.1.nikula@nokia.com>
Cc: david-b@pacbell.net, linux-kernel@vger.kernel.org,
       ext-jani.1.nikula@nokia.com
Subject: Re: [PATCH] gpiolib: allow exported GPIO nodes to be named using
 sysfs links
Message-Id: <20090622122547.bc672764.akpm@linux-foundation.org>
In-Reply-To: <1244711943-15364-1-git-send-email-ext-jani.1.nikula@nokia.com>
References: <1244711943-15364-1-git-send-email-ext-jani.1.nikula@nokia.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Jun 2009 12:19:03 +0300
Jani Nikula <ext-jani.1.nikula@nokia.com> wrote:

> +int gpio_export_link(struct device *dev, const char *name, unsigned gpio)
> +{
> +	struct gpio_desc	*desc;
> +	int			status = -EINVAL;
> +
> +	BUG_ON(dev == NULL);
> +	BUG_ON(name == NULL);

We usually don't bother with these assertions.  If the kernel will
reliably oops if one of these is NULL, then that provides the same
information anyway.

