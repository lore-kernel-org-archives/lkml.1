Return-Path: <linux-kernel-owner+w=401wt.eu-S1765370AbXEWLDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765370AbXEWLDY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 07:03:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763583AbXEWLDH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 07:03:07 -0400
Received: from hobbit.corpit.ru ([81.13.94.6]:20962 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762017AbXEWLDF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 07:03:05 -0400
Message-ID: <46541F65.9060507@msgid.tls.msk.ru>
Date: Wed, 23 May 2007 15:03:01 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH] add "notime" boot option
References: <20070522120938.db67f1e9.randy.dunlap@oracle.com>
In-Reply-To: <20070522120938.db67f1e9.randy.dunlap@oracle.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> 
> Add "notime" boot option to prevent timing data from being printed on
> each printk message line.

That's a good source of confusion.  To me, "notime" means something
like "don't bother calculating time", instead of the proposed
behavior.  Can't it be something like 'nologts' (no log timestamps)
or nots or notimestamps or nologtime instead?

/mjt
