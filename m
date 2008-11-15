Return-Path: <linux-kernel-owner+w=401wt.eu-S1755890AbYKOTUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890AbYKOTUs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 14:20:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751963AbYKOTUk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 14:20:40 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:51372 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734AbYKOTUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 14:20:40 -0500
Subject: Re: [PATCH] depmod: sort output according to modules.order, take #2
From: Jon Masters <jonathan@jonmasters.org>
To: Tejun Heo <htejun@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Sam Ravnborg <sam@ravnborg.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, notting@redhat.com,
       kay.sievers@vrfy.org, Greg KH <greg@kroah.com>
In-Reply-To: <491C1158.8090901@gmail.com>
References: <475936CE.70703@gmail.com> <475BB5AE.40503@gmail.com>
	 <477B71F0.8020706@gmail.com>  <200801031012.22776.rusty@rustcorp.com.au>
	 <1199318319.2044.22.camel@perihelion>  <491C1158.8090901@gmail.com>
Content-Type: text/plain
Organization: World Organi[sz]ation Of Broken Dreams
Date: Sat, 15 Nov 2008 14:20:13 -0500
Message-Id: <1226776813.4894.1.camel@jcmlaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 173.9.31.177
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-11-13 at 20:36 +0900, Tejun Heo wrote:

> Jon, this patch hasn't made into module-init-tools

I'm redoing it to cope with the binary sorted output files we have now -
i.e. we can't just rely upon the order of modules.dep any more, what
you're actually trying to do with modules.order is ensure that e.g.
modules providing conflicting aliases get handled in "order".

I'll followup.

Jon.


