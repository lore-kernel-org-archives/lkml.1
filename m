Return-Path: <linux-kernel-owner+w=401wt.eu-S1757451AbXKFV01@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757451AbXKFV01 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 16:26:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754314AbXKFV0T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 16:26:19 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:40164 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753650AbXKFV0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 16:26:19 -0500
Date: Tue, 6 Nov 2007 13:24:26 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [patch 1/4] Create arch/Kconfig
Message-Id: <20071106132426.1e12b065.randy.dunlap@oracle.com>
In-Reply-To: <4730D8B7.7020909@zytor.com>
References: <20071106203724.620893371@polymtl.ca>
	<20071106204151.811746387@polymtl.ca>
	<4730D8B7.7020909@zytor.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 Nov 2007 13:12:23 -0800 H. Peter Anvin wrote:

> Ideally architecture should be a Kconfig option (it's not needed before 
> config runs, unlike, say HOSTCC.)
> 
> That might take some major surgery, though.

I think that's what Sam was going to try to get to.
He said that we need all ARCHes to source "drivers/Kconfig",
so I did cris.  About 5 more ARCHes need conversions.

---
~Randy
