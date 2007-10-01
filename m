Return-Path: <linux-kernel-owner+w=401wt.eu-S1753369AbXJAPWG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369AbXJAPWG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 11:22:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751661AbXJAPVz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 11:21:55 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53133 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbXJAPVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 11:21:55 -0400
Date: Mon, 1 Oct 2007 17:21:53 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <andi@firstfloor.org>,
       Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Fwd: x86_64 and AMD with C1E
Message-ID: <20071001152153.GB19797@one.firstfloor.org>
References: <20071001101532.025d652f@localhost> <p73r6kf6uwz.fsf@bingen.suse.de> <b70f2f960710010546k4658aa1ay466f243ac707c989@mail.gmail.com> <b70f2f960710010550i30ae48bu31f137fe46d70611@mail.gmail.com> <alpine.LRH.0.999.0710011612001.7353@www.tglx.de> <20071001143225.GA19797@one.firstfloor.org> <alpine.LRH.0.999.0710011652470.7353@www.tglx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.0.999.0710011652470.7353@www.tglx.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> So if the
> number of hpet channels is greater/equal to the number of possible
> CPUs it's perfectly fine and does not need IPI at all.

That is only a stop gap then. I don't see this being
generally true in the future. e.g. Intel announced SMT will be soon 
back so even a standard dual core would exceed it with
current southbridges.

Also I'm not sure but I suspect non Intel HPETs have less than
three timers. Certainly they generally miss the 64bitness.

-Andi
