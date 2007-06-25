Return-Path: <linux-kernel-owner+w=401wt.eu-S1754599AbXFYMR2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599AbXFYMR2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 08:17:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752614AbXFYMRF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 08:17:05 -0400
Received: from esuna.co.uk ([83.223.102.198]:51722 "EHLO mail.esuna.co.uk"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752495AbXFYMRE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 08:17:04 -0400
Message-ID: <467FB237.2030703@esuna.co.uk>
Date: Mon, 25 Jun 2007 13:16:55 +0100
From: "Jay L. T. Cornwall" <jay@esuna.co.uk>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
MIME-Version: 1.0
To: Jay Cliburn <jacliburn@bellsouth.net>
CC: linux-kernel@vger.kernel.org, kronos.it@gmail.com,
       Chris Snook <csnook@redhat.com>
Subject: Attansic L1 page corruption (was: 2.6.22-rc5: pdflush oops under
 heavy disk load)
References: <467B12CA.5060405@esuna.co.uk>	<467BE118.4090308@redhat.com>	<467BE4F1.7040308@esuna.co.uk>	<467D0EB0.9030100@esuna.co.uk>	<20070624125957.2e27820c@osprey.hogchain.net>	<467ED4A8.4080500@esuna.co.uk> <20070624164519.04f215b8@osprey.hogchain.net>
In-Reply-To: <20070624164519.04f215b8@osprey.hogchain.net>
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jay Cliburn wrote:

> For reasons not yet clear to me, it appears the L1 driver has a bug or
> the device itself has trouble with DMA in high memory.  This patch,
> drafted by Luca Tettamanti, is being explored as a workaround.  I'd be
> interested to know if it fixes your problem.

Yes, it certainly seems to. Now running with this patch and 4GB active,
I've transferred about 15GB with no problem so far. It usually oopses
after a GB or two.

I guess it's not an ideal solution, architecturally speaking, but it's a
good deal better than an unstable driver. If there's any other patches
you'd like me to test or traces to capture, I'm happy to help out.
Otherwise I'll run with this one for now since it does the job!

Thanks.

-- 
Jay L. T. Cornwall, http://www.esuna.co.uk/~jay/
PhD Student
Imperial College London
