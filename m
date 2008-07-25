Return-Path: <linux-kernel-owner+w=401wt.eu-S1756176AbYGYJFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176AbYGYJFy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 05:05:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753974AbYGYJFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 05:05:46 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:61294 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753608AbYGYJFp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 05:05:45 -0400
Date: Fri, 25 Jul 2008 11:05:03 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Ben Dooks <ben-linux@fluff.org>
Cc: Pierre Ossman <drzeus-list@drzeus.cx>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/3] mmc: Add per-card debugfs support
Message-ID: <20080725110503.5be65b71@siona.local>
In-Reply-To: <20080725082424.GD8301@fluff.org.uk>
References: <1216901939-4187-1-git-send-email-haavard.skinnemoen@atmel.com>
	<1216901939-4187-2-git-send-email-haavard.skinnemoen@atmel.com>
	<20080725082424.GD8301@fluff.org.uk>
Organization: Atmel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Jul 2008 09:05:02.0583 (UTC) FILETIME=[85D16870:01C8EE35]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jul 2008 09:24:24 +0100
Ben Dooks <ben-linux@fluff.org> wrote:

> out of interest, why not have an standard sysfs node for the
> current voltage setting?

Dunno. Because nobody has added it? ;-)

> > Changes since v2:
> >   * Don't rely on the compiler to optimize out unused code
> 
> which compiler? the gcc 4 series seem quite good at it, gcc 3.4
> and later tended to eliminate only the code and not the associated
> data created with it.

4.2.x. It got rid of the code, the data associated with the code, but
not the code associated with that data again (i.e. the file operations
hooks).

> > +#ifdef CONFIG_DEBUG_FS
> > +	mmc_add_card_debugfs(card);
> > +#endif
> > +
> 
> why not make mmc_add_card_debugfs() an empty function
> in the header if there is no debugfs support?

Because Pierre didn't like it.

Haavard
