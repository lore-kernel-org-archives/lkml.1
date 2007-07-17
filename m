Return-Path: <linux-kernel-owner+w=401wt.eu-S1764712AbXGQAvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764712AbXGQAvQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 20:51:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755443AbXGQAvC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 20:51:02 -0400
Received: from qsrv03ps.mx.bigpond.com ([144.140.82.183]:17650 "EHLO
	qsrv03ps.mx.bigpond.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755426AbXGQAvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 20:51:00 -0400
Message-ID: <469C08BF.5010406@bigpond.net.au>
Date: Tue, 17 Jul 2007 10:09:35 +1000
From: Peter Williams <pwil3058@bigpond.net.au>
User-Agent: Thunderbird 2.0.0.4 (X11/20070613)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE][RFC] PlugSched-6.5.1 for  2.6.22
References: <46946E39.5090108@bigpond.net.au> <20070716082025.GA29529@elte.hu>
In-Reply-To: <20070716082025.GA29529@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Authentication-Info: Submitted using SMTP AUTH PLAIN at oaamta07ps.mx.bigpond.com from [124.185.129.152] using ID pwil3058@bigpond.net.au at Tue, 17 Jul 2007 00:10:09 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Peter Williams <pwil3058@bigpond.net.au> wrote:
> 
>> Probably the last one now that CFS is in the main line :-(.
> 
> hm, why is CFS in mainline a problem?

It means a major rewrite of the plugsched interface and I'm not sure
that it's worth it (if CFS works well).  However, note that I did say
probably not definitely :-).  I'll play with it and see what happens.

> The CFS merge should make the life 
> of development/test patches like plugsched conceptually easier. (it will 
> certainly cause a lot of churn, but that's for the better i think.)

I don't think that is necessarily the case.

> 
> Most of the schedulers in plugsched should be readily adaptable to the 
> modular scheduling-policy scheme of the upstream scheduler.

I don't think that this necessarily true.  Ingosched and ingo_ll are
definitely out and I don't feel like converting staircase and nicksched
as I have no real interest in them.  Perhaps I'll just create the
interface and some schedulers based on my own ideas and let others such
as Con and Nick add schedulers if they're still that way inclined.

> I'm sure 
> there will be some minor issues as isolation of the modules is not 
> enforced right now - and i'd be happy to review (and potentially apply) 
> common-sense patches that improve the framework.

Thanks for the offer of support (it may sway my decision),
Peter
-- 
Peter Williams                                   pwil3058@bigpond.net.au

"Learning, n. The kind of ignorance distinguishing the studious."
 -- Ambrose Bierce
