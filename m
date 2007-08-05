Return-Path: <linux-kernel-owner+w=401wt.eu-S1759564AbXHES62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759564AbXHES62 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 14:58:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754827AbXHES6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 14:58:21 -0400
Received: from jade.padinet.com ([202.6.233.250]:4689 "HELO owl.postpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752907AbXHES6U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 14:58:20 -0400
Date: Mon, 6 Aug 2007 01:58:39 +0700
From: adi <adi@postpi.com>
To: Dave Jones <davej@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, J??rn Engel <joern@logfs.org>,
       Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       miklos@szeredi.hu, akpm@linux-foundation.org, neilb@suse.de,
       dgc@sgi.com, tomoki.sekiyama.qu@hitachi.com, nikita@clusterfs.com,
       trond.myklebust@fys.uio.no, yingchao.zhou@gmail.com,
       richard@rsk.demon.co.uk, david@lang.hm
Subject: Re: [PATCH 00/23] per device dirty throttling -v8
Message-ID: <20070805185839.GA5071@postpi.com>
References: <alpine.LFD.0.999.0708041030040.5037@woody.linux-foundation.org> <46B4C0A8.1000902@garzik.org> <20070804191205.GA24723@lazybastard.org> <20070804192130.GA25346@elte.hu> <20070804211156.5f600d80@the-village.bc.nu> <20070804202830.GA4538@elte.hu> <20070804210351.GA9784@elte.hu> <20070804225121.5c7b66e0@the-village.bc.nu> <20070805072141.GA4414@elte.hu> <20070805184408.GB22639@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070805184408.GB22639@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 05, 2007 at 02:44:08PM -0400, Dave Jones wrote:
> It still fails miserably for me.
> 
> If I hit 'C' and '?' I get a list of my mail folders, with some of them
> marked 'N' if they have new mail.  Without atime, those N's never show
> up and every mbox looks like it has no new mail.

This is true for one using mbox_type=mbox (i.e unix native mailbox
format). Maildir type should work just fine as mutt will noticed
that new mail has arrived on 'new' subdir (according to maildir spec).

Then yes, it is configuration dependent.

Regards,

P.Y. Adi Prasaja
