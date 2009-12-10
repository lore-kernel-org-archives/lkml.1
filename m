Return-Path: <linux-kernel-owner+w=401wt.eu-S1758966AbZLJADq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758966AbZLJADq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 19:03:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758892AbZLJADp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 19:03:45 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34919 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758841AbZLJADo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 19:03:44 -0500
Date: Wed, 9 Dec 2009 16:02:54 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jani Nikula <ext-jani.1.nikula@nokia.com>
Cc: dbrownell@users.sourceforge.net, gregkh@suse.de,
       linux-kernel@vger.kernel.org, dsilvers@simtec.co.uk, ben@simtec.co.uk,
       Artem.Bityutskiy@nokia.com
Subject: Re: [PATCH 0/3] gpiolib: gpio naming in sysfs
Message-Id: <20091209160254.4fdd64b9.akpm@linux-foundation.org>
In-Reply-To: <cover.1260364108.git.ext-jani.1.nikula@nokia.com>
References: <cover.1260364108.git.ext-jani.1.nikula@nokia.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  9 Dec 2009 15:49:01 +0200
Jani Nikula <ext-jani.1.nikula@nokia.com> wrote:

> Hi David and Greg -
> 
> There's been debate in the past about naming gpios exported to the
> sysfs. Long story short, there are users for that, and there are now
> two ways of naming gpios in the sysfs: char **names in struct
> gpio_chip [1], and gpio_export_link() [2].
> 
> This patchset combines these two by allowing gpio_export_link() to
> have dev == NULL to make the link under gpiolib sysfs (instead of
> arbitrary device), and to use gpio_chip names to create links (instead
> of naming the actual devices with those). This gpio_export_link() with
> dev == NULL would also be useful for gpios not associated with a
> driver.
> 
> Greg, patch 1/3 introduces class_{create,remove}_link(), is that
> acceptable?
> 
> CC Daniel, you introduced names in struct gpio_chip in the first
> place, does this (especially patch 3/3) look acceptable to you?
> 

I haven't seen an email from David in perhaps two months, so we're on
our own in this.

Can you please remind us what the earlier objections were, and tell us
how this patchset addresses them?

Thanks.
