Return-Path: <linux-kernel-owner+w=401wt.eu-S1754837AbZFUAnO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837AbZFUAnO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 20:43:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752411AbZFUAnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 20:43:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38612 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752193AbZFUAnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 20:43:07 -0400
Date: Sat, 20 Jun 2009 17:42:53 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Maxim Levitsky <maximlevitsky@gmail.com>
cc: Dave Airlie <airlied@linux.ie>, dri-devel@lists.sf.net,
       linux-kernel@vger.kernel.org
Subject: Re: [git pull] drm: previous pull req + 1.
In-Reply-To: <1245542690.6104.6.camel@localhost>
Message-ID: <alpine.LFD.2.01.0906201741290.3119@localhost.localdomain>
References: <alpine.DEB.2.00.0906200619520.27130@skynet.skynet.ie> <1245542690.6104.6.camel@localhost>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 21 Jun 2009, Maxim Levitsky wrote:
> 
> Something from this tree breaks my i965.
> Using -git just before this was pulled,
> 
>  a552f0af753eb4b5bbbe9eff205fe874b04c4583 works, but using latest git
> 
> makes google earth stall, it doesn't update its main window. It appears
> that openining and closing its menu, allows it to progress frame after
> frame. No crashes hangs however.

Can you bisect? There's not a tons of commit there, so it shouldn't be 
more than a couple of recompiles/reboots, and you'd be able to pinpoint 
the exact commit that breaks. That will help people figure it out, or at 
worst just pinpoint what we need to revert.

		Linus
