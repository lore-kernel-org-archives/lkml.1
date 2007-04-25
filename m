Return-Path: <linux-kernel-owner+w=401wt.eu-S2993041AbXDYUGJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993041AbXDYUGJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 16:06:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993042AbXDYUGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 16:06:09 -0400
Received: from mail.suse.de ([195.135.220.2]:33841 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993041AbXDYUGH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 16:06:07 -0400
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
X-Yow: OMNIVERSAL AWARENESS??  Oh, YEH!!  First you need 4 GALLONS of JELL-O
 and a BIG WRENCH!!...  I think you drop th'WRENCH in the JELL-O as if
 it was a FLAVOR, or an INGREDIENT...  ...or...I...um...  WHERE'S the
 WASHING MACHINES?
Date: Wed, 25 Apr 2007 22:05:54 +0200
In-Reply-To: <Pine.LNX.4.61.0704251418010.26778@chaos.analogic.com>
	(linux-os@analogic.com's message of "Wed, 25 Apr 2007 14:24:12 -0400")
Message-ID: <jetzv41aot.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.97 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"linux-os (Dick Johnson)" <linux-os@analogic.com> writes:

> I think this works, regardless of the length of the integers:
>
> #define abs(x) (((x)<0)?-(x):(x))

But it evaluates its argument more than once.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
