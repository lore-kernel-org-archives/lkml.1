Return-Path: <linux-kernel-owner+w=401wt.eu-S933599AbXCTFgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933599AbXCTFgi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 01:36:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933618AbXCTFgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 01:36:38 -0400
Received: from tomts22-srv.bellnexxia.net ([209.226.175.184]:58484 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933599AbXCTFgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 01:36:37 -0400
Subject: Re: [BUG] 2.6.21-rc1,2,3 regressions on my system that I found so
	far
From: Eric St-Laurent <ericstl34@sympatico.ca>
To: Lee Revell <rlrevell@joe-job.com>
Cc: tglx@linutronix.de, Maxim Levitsky <maximlevitsky@gmail.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, Adrian Bunk <bunk@stusta.de>,
       Arjan van de Ven <arjan@infradead.org>, Len Brown <lenb@kernel.org>
In-Reply-To: <75b66ecd0703192204n503eb4d3g361064f66319dd4c@mail.gmail.com>
References: <200703161230.03712.maximlevitsky@gmail.com>
	 <1174088686.13341.347.camel@localhost.localdomain>
	 <75b66ecd0703192204n503eb4d3g361064f66319dd4c@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 20 Mar 2007 01:36:35 -0400
Message-Id: <1174368995.14239.3.camel@perkele>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-20-03 at 01:04 -0400, Lee Revell wrote:

> I think CONFIG_TRY_TO_DISABLE_SMI would be excellent for debugging,
> not to mention people trying to spec out hardware for RT
> applications...

There is a SMI disabling module in RTAI, check the smi-module.c in this:

https://www.rtai.org/RTAI/rtai-3.5.tar.bz2

More infos:

http://www.captain.at/rtai-smi-high-latency.php
http://www.captain.at/xenomai-smi-high-latency.php

It might make sense to merge this code, at least in the -rt tree.


- Eric


