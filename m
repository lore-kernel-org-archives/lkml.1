Return-Path: <linux-kernel-owner+w=401wt.eu-S1759207AbXENUev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759207AbXENUev (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 16:34:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758151AbXENUem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 16:34:42 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:48698 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757926AbXENUel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 16:34:41 -0400
Date: Mon, 14 May 2007 13:33:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       john stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH] timekeeping fix mismerge
Message-Id: <20070514133333.3154d08d.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0705141218390.6739@woody.linux-foundation.org>
References: <1179133802.22481.327.camel@localhost.localdomain>
	<alpine.LFD.0.98.0705141218390.6739@woody.linux-foundation.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 May 2007 12:25:02 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> I don't think re-generating the diff is wrong, and in fact I think you 
> have to do it, but I think Andrew should use "--fuzz=0" or at least 
> "--fuzz=1" instead of the default 2. Yeah, it obviously causes more patch 
> application failures, and it can be very irritating if *most* of those 
> patches would have applied cleanly and correctly with --fuzz=2, but 
> --fuzz=2 really is very dangerous. It literally just needed two lines to 
> match in the wrong place (and as mentioned, those two lines can be 
> trivial, like in the example - totally empty, even!)

Yeah I played with that a while back and --fuzz=0 just broken everything.

--fuzz=1 seems acceptable though.  I'll use that from now on.

