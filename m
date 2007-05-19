Return-Path: <linux-kernel-owner+w=401wt.eu-S1759275AbXESQ3h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759275AbXESQ3h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 12:29:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754518AbXESQ32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 12:29:28 -0400
Received: from relay.2ka.mipt.ru ([194.85.82.65]:33084 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754297AbXESQ31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 12:29:27 -0400
Date: Sat, 19 May 2007 20:27:15 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Jamie Lokier <jamie@shareable.org>
Cc: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>,
       John Stoffel <john@stoffel.org>, David Woodhouse <dwmw2@infradead.org>,
       akpm@osdl.org, Albert Cahalan <acahalan@gmail.com>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       Ingo Oeser <ioe-lkml@rameria.de>, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-mtd@lists.infradead.org, Jan Engelhardt <jengelh@linux01.gwdg.de>,
       linux-fsdevel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] LogFS take three
Message-ID: <20070519162714.GA7383@2ka.mipt.ru>
References: <17994.1241.436841.681216@stoffel.org> <20070515191926.GB1220@lazybastard.org> <1179291255.2859.195.camel@shinybook.infradead.org> <20070516110933.GA5472@lazybastard.org> <20070516113434.GC20482@mail.shareable.org> <20070516115003.GD5472@lazybastard.org> <17995.2550.581854.8393@stoffel.org> <20070516135318.GK5472@lazybastard.org> <20070519144556.GS11766@vasa.acc.umu.se> <20070519161732.GA14324@mail.shareable.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070519161732.GA14324@mail.shareable.org>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Sat, 19 May 2007 20:27:27 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 19, 2007 at 05:17:32PM +0100, Jamie Lokier (jamie@shareable.org) wrote:
> > So, log2fs...  Sounds great to me.
> 
> Why Log2?  Logarithmic scaling is just logarithmic scaling.  Does the
> filesystem use 2-ary trees or anything else which gives particular
> meaning to 2?

Sizes used in on-disk format are rounded to the nearest power-of-two.

> -- Jamie

-- 
	Evgeniy Polyakov
