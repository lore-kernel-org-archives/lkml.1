Return-Path: <linux-kernel-owner+w=401wt.eu-S1757316AbXK0JMH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757316AbXK0JMH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 04:12:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751169AbXK0JLx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 04:11:53 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:55764 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751076AbXK0JLw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 04:11:52 -0500
Date: Tue, 27 Nov 2007 10:11:25 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>, LKML <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] mmc: Add missing sg_init_table() call
Message-ID: <20071127101125.49770e42@dhcp-255-175.norway.atmel.com>
In-Reply-To: <20071126212955.07f65b0d.akpm@linux-foundation.org>
References: <1195759971-19825-1-git-send-email-hskinnemoen@atmel.com>
	<20071126212955.07f65b0d.akpm@linux-foundation.org>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.1.0-rc1 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Nov 2007 21:29:55 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 22 Nov 2007 20:32:51 +0100 Haavard Skinnemoen <hskinnemoen@atmel.com> wrote:
> 
> > mmc_init_queue only initializes the scatterlists with sg_init_table()
> > when using a bounce buffer. This leads to a BUG() when CONFIG_DEBUG_SG
> > is set.
> >   
> 
> I assume that 2.6.23 is not afflicted in this way?

Yes, the sg_init_table() interface and CONFIG_DEBUG_SG were both added
after 2.6.23. Before that, there was no need to do anything special to
initialize a scatterlist array apart from zeroing it.

Haavard
