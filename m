Return-Path: <linux-kernel-owner+w=401wt.eu-S1756501AbXKZVW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756501AbXKZVW6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 16:22:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754285AbXKZVWu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 16:22:50 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:32787 "EHLO
	dorka.pomaz.szeredi.hu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753858AbXKZVWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 16:22:49 -0500
To: jdike@addtoit.com
CC: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@elte.hu
In-reply-to: <20071126205242.GA11444@c2.user-mode-linux.org> (message from
	Jeff Dike on Mon, 26 Nov 2007 15:52:42 -0500)
Subject: Re: uml doesn't work on 2.6.24-rc2
References: <E1Is5FL-00078H-00@dorka.pomaz.szeredi.hu> <20071114011002.GA11477@c2.user-mode-linux.org> <E1IsFbA-0007y2-00@dorka.pomaz.szeredi.hu> <20071114142247.GA5848@c2.user-mode-linux.org> <E1IsK83-0008CJ-00@dorka.pomaz.szeredi.hu> <20071126205242.GA11444@c2.user-mode-linux.org>
Message-Id: <E1IwlPY-0000Q7-0r@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 26 Nov 2007 22:22:36 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, Nov 14, 2007 at 04:26:11PM +0100, Miklos Szeredi wrote:
> > This one fixed the EINVAL messages, and now UML boots, but consumes
> > 100% CPU constantly.
> 
> Can you disable NO_HZ and try the patch below, which WorksForMe (TM)?

Yes, it fixes the busy looping for me as well.  Thanks!

There's still something strange, as top shows 50% time spent in I/O
wait when UML is running.  But ps doesn't show any process in "D"
state.

Can't remember seeing this earlier.

Miklos
