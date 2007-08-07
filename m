Return-Path: <linux-kernel-owner+w=401wt.eu-S936377AbXHGXEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936377AbXHGXEY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 19:04:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760761AbXHGXEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 19:04:14 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36681 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758313AbXHGXEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 19:04:13 -0400
Date: Tue, 7 Aug 2007 16:03:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Grant Grundler <grundler@parisc-linux.org>,
       Kyle McMartin <kyle@mcmartin.ca>
Subject: Re: [RFC][PATCH] uli526x: Add suspend and resume routines
Message-Id: <20070807160357.d6ea9731.akpm@linux-foundation.org>
In-Reply-To: <200708052114.01790.rjw@sisk.pl>
References: <200708052114.01790.rjw@sisk.pl>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 Aug 2007 21:14:01 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> +#ifdef CONFIG_PM_SLEEP
> +
> +/*
> + *	Suspend the interface.
> + */
> +
> +static int uli526x_suspend(struct pci_dev *pdev, pm_message_t state)

Since when did suspend and resume methods become dependent upon CONFIG_PM_SLEEP?

We have eight thousand implementations of this, all of which presently
use CONFIG_PM.
