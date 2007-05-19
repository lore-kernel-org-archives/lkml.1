Return-Path: <linux-kernel-owner+w=401wt.eu-S1760687AbXESQTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760687AbXESQTT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 12:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754518AbXESQTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 12:19:10 -0400
Received: from mail.shareable.org ([81.29.64.88]:56720 "EHLO
	mail.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754488AbXESQTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 12:19:08 -0400
Date: Sat, 19 May 2007 17:17:32 +0100
From: Jamie Lokier <jamie@shareable.org>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>,
       John Stoffel <john@stoffel.org>, David Woodhouse <dwmw2@infradead.org>,
       akpm@osdl.org, Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Albert Cahalan <acahalan@gmail.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, Ingo Oeser <ioe-lkml@rameria.de>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-mtd@lists.infradead.org,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, linux-fsdevel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] LogFS take three
Message-ID: <20070519161732.GA14324@mail.shareable.org>
References: <20070515151919.GA32510@lazybastard.org> <17994.1241.436841.681216@stoffel.org> <20070515191926.GB1220@lazybastard.org> <1179291255.2859.195.camel@shinybook.infradead.org> <20070516110933.GA5472@lazybastard.org> <20070516113434.GC20482@mail.shareable.org> <20070516115003.GD5472@lazybastard.org> <17995.2550.581854.8393@stoffel.org> <20070516135318.GK5472@lazybastard.org> <20070519144556.GS11766@vasa.acc.umu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070519144556.GS11766@vasa.acc.umu.se>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Weinehall wrote:
> > It is also the filesystem that tries to scale logarithmically, as Arnd
> > has noted.  Maybe I should call it Log2 to emphesize this point.  Log1
> > would be horrible scalability.
> 
> So, log2fs...  Sounds great to me.

Why Log2?  Logarithmic scaling is just logarithmic scaling.  Does the
filesystem use 2-ary trees or anything else which gives particular
meaning to 2?

-- Jamie
