Return-Path: <linux-kernel-owner+w=401wt.eu-S1755309AbYFNHMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309AbYFNHMV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 03:12:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752271AbYFNHMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 03:12:09 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47491
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752229AbYFNHMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 03:12:07 -0400
Date: Sat, 14 Jun 2008 00:12:06 -0700 (PDT)
Message-Id: <20080614.001206.153530204.davem@davemloft.net>
To: mingo@elte.hu
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org, rjw@sisk.pl
Subject: Re: [GIT]: Networking
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080614060320.GA18454@elte.hu>
References: <20080612.211959.52937006.davem@davemloft.net>
	<20080614060320.GA18454@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Sat, 14 Jun 2008 08:03:20 +0200

> once i added the patch below this new warning went away. I'm wondering 
> what this difference is about and why your revert differs from Ilpo's. 

Because I reverted the change we found bugs in.

Ilpo sent you a patch which reverted an entire series of changes
purely so that we could begin to narrow things down.

> It might as well be the right thing to do and the warning just shows 
> something latent.

This is my though still currently because I can't see any reason why
the diff you keep posting would cause a device to transmit timeout.
It's likely a timing thing or something weird like that.
