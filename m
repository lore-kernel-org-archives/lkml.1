Return-Path: <linux-kernel-owner+w=401wt.eu-S1755928Ab0AVRFK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928Ab0AVRFK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 12:05:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755904Ab0AVRFJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 12:05:09 -0500
Received: from mail.vyatta.com ([76.74.103.46]:45192 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755130Ab0AVRFI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 12:05:08 -0500
Date: Fri, 22 Jan 2010 09:04:41 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andi Kleen <andi@firstfloor.org>, Joe Perches <joe@perches.com>,
       linux-kernel@vger.kernel.org, Marcin Slusarz <marcin.slusarz@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 00/24] drivers/block/floppy.c cleanups
Message-ID: <20100122090441.10716815@nehalam>
In-Reply-To: <20100122114653.4afd606d@lxorguk.ukuu.org.uk>
References: <cover.1264133863.git.joe@perches.com>
	<87fx5yh0va.fsf@basil.nowhere.org>
	<20100122114653.4afd606d@lxorguk.ukuu.org.uk>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Jan 2010 11:46:53 +0000
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > Philosophically I'm not sure it's that great an idea to make bad code
> > look better without actually fixing/rewriting it. It's like putting
> > lipstick on a pig.
> 
> Unpacking the mess and sorting out the whacky macros is more like
> removing all muck from the mechanism so you can see what needs to be done.
> 
> So I disagree - its a useful first step only

I had a reason in motivating this. For some cases, customers use floppy as
a configuration storage, and there were a number of strange errors
showing up occasionally in recent kernels. But the driver is such
an old crufty mess, it wasn't worth investigating further.

Making the code clearer gets rid of that excuse.

-- 
