Return-Path: <linux-kernel-owner+w=401wt.eu-S1759969AbYBLFR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759969AbYBLFR3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 00:17:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753659AbYBLFRJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 00:17:09 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:34646 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128AbYBLFRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 00:17:07 -0500
Date: Mon, 11 Feb 2008 21:16:53 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: jengelh@computergmbh.de, linux-kernel@vger.kernel.org, mingo@elte.hu,
       davej@redhat.com
Subject: Re: [PATCH] make /dev/kmem a config option
Message-ID: <20080211211653.301ab24d@laptopd505.fenrus.org>
In-Reply-To: <20080211205914.f357d179.akpm@linux-foundation.org>
References: <20080210155534.17fc6e5e@laptopd505.fenrus.org>
	<Pine.LNX.4.64.0802110111160.7915@fbirervta.pbzchgretzou.qr>
	<20080210170509.36999240@laptopd505.fenrus.org>
	<20080211143804.76f9743f.akpm@linux-foundation.org>
	<20080211200329.2b272759@laptopd505.fenrus.org>
	<20080211205914.f357d179.akpm@linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Feb 2008 20:59:14 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Mon, 11 Feb 2008 20:03:29 -0800 Arjan van de Ven
> <arjan@infradead.org> wrote:
> 
> > +config DEVKMEM
> > +	bool "/dev/kmem virtual device support"
> > +	help
> > +	  Say Y here if you want to support the /dev/kmem device.
> > The
> > +	  /dev/kmem device is rarely used, but can be used for
> > certain
> > +	  kind of kernel debugging operations.
> > +	  When in doubt, say "N".
> 
> I think this should be `default y'.  So that we don't cause /dev/kmem
> to magically disappear for `make oldconfig' users.

that's a matter of taste; nothing uses/needs it and I think people are better
off without it (by default), but if you insist I can't object to that too much
either.


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
