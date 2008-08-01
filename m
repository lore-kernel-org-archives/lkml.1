Return-Path: <linux-kernel-owner+w=401wt.eu-S1754206AbYHAORm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206AbYHAORm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 10:17:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752214AbYHAORf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 10:17:35 -0400
Received: from one.firstfloor.org ([213.235.205.2]:37600 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168AbYHAORe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 10:17:34 -0400
Date: Fri, 1 Aug 2008 16:17:43 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <andi@firstfloor.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] x86: implement multiple queues for smp function call IPIs
Message-ID: <20080801141743.GV23938@one.firstfloor.org>
References: <488FA8A9.6000005@goop.org> <20080731220825.GD23801@elte.hu> <48923B7A.3020805@goop.org> <20080731224202.GB22426@elte.hu> <4892980A.2010101@goop.org> <20080801090910.GA3282@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080801090910.GA3282@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So ... how about my original suggestion, to add a (default-off) boot 
> option that reduces the queues to 1? I.e. lets have something in place 
> from day 1 on that could be quirk-handler-driven, should the need arise. 
> "apic=simpleipi" or something like that.
> 
> In a year or two, once this all has proven itself fine on a broad range 
> of systems, we'll laugh out loud at being so cautious and can remove the 
> boot option for good ;-)

I agree that adding a boot option to turn it off is a good idea (assuming
it doesn't take too much code to implement) Adding such paranoid boot options early 
has saved my ass a few times in the past.

Only tricky bit is use if () not "modulo variable", because the if ()
will be much faster than a division through an arbitary number.

-Andi
