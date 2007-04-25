Return-Path: <linux-kernel-owner+w=401wt.eu-S1754277AbXDYV6H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277AbXDYV6H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 17:58:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754285AbXDYV6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 17:58:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43365 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754277AbXDYV6G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 17:58:06 -0400
From: Andreas Schwab <schwab@suse.de>
To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Cc: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>,
       "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Richard Knutsson" <ricknu-0@student.ltu.se>,
       "Jiri Bohac" <jbohac@suse.cz>, <akpm@osdl.org>,
       "Linux kernel" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] fix abs() macro to work with types wider than int
References: <20070419092339.GA13569@dwarf.suse.cz>
	<20070419084339.418dbe69.randy.dunlap@oracle.com>
	<4628B5B6.90303@student.ltu.se>
	<20070425082028.8ece3094.randy.dunlap@oracle.com>
	<alpine.DEB.0.98.0704251123370.19149@sigma.j-a-k-j.com>
	<Pine.LNX.4.61.0704251418010.26778@chaos.analogic.com>
	<jetzv41aot.fsf@sykes.suse.de>
	<Pine.LNX.4.61.0704251612090.27302@chaos.analogic.com>
X-Yow: Here we are in America...  when do we collect unemployment?
Date: Wed, 25 Apr 2007 23:57:53 +0200
In-Reply-To: <Pine.LNX.4.61.0704251612090.27302@chaos.analogic.com>
	(linux-os@analogic.com's message of "Wed, 25 Apr 2007 16:30:29 -0400")
Message-ID: <jehcr415i6.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.97 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"linux-os (Dick Johnson)" <linux-os@analogic.com> writes:

> The original query was for a macro.

A macro that does not evaluate its argument more than once.  If you want
it to match the behaviour as defined by the C standard then it is not
allowed to do so.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
