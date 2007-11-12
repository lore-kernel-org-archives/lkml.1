Return-Path: <linux-kernel-owner+w=401wt.eu-S1758096AbXKLIU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758096AbXKLIU3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 03:20:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754590AbXKLIUU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 03:20:20 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:44029 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090AbXKLIUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 03:20:19 -0500
Subject: Re: [rfc][patch] remove nopage
From: Jon Masters <jonathan@jonmasters.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <1194855408.5946.88.camel@perihelion>
References: <20071112015643.GA9291@wotan.suse.de>
	 <1194855408.5946.88.camel@perihelion>
Content-Type: text/plain
Organization: World Organi[sz]ation Of Broken Dreams
Date: Mon, 12 Nov 2007 03:19:45 -0500
Message-Id: <1194855585.5946.91.camel@perihelion>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2007-11-12 at 03:17 -0500, Jon Masters wrote:
> On Mon, 2007-11-12 at 02:56 +0100, Nick Piggin wrote:
> 
> > This is a patch to remove 'nopage' from the tree.
> 
> Interesting, but why now? What precipitated this?

Actually reading said patch and thinking helps. I'll go hide back under
my rock now...

What:  vm_ops.nopage
When:  Soon, provided in-kernel callers have been converted
Why:   This interface is replaced by vm_ops.fault, but it has been
       around forever, is used by a lot of drivers, and doesn't cost
       much to maintain.

Jon.


