Return-Path: <linux-kernel-owner+w=401wt.eu-S966065AbXCTBnz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966065AbXCTBnz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 21:43:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966067AbXCTBnz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 21:43:55 -0400
Received: from gherkin.frus.com ([192.158.254.49]:51179 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966065AbXCTBny (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 21:43:54 -0400
Subject: Re: [BUG] no boot with 2.6.21-rc3 and later
To: linux-kernel@vger.kernel.org
Date: Mon, 19 Mar 2007 19:43:53 -0600 (CST)
CC: jikos@jikos.cz, bzolnier@gmail.com
X-Mailer: ELM [version 2.4ME+ PL82 (25)]
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Message-Id: <20070320014353.B1B05DBA1@gherkin.frus.com>
From: rct@gherkin.frus.com (Bob Tracy)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri wrote:
> Looks like it's related to some change in drivers/ide. As there have been 
> only 13 patches in this area between rc2 and rc3, it should take only 3 or 
> 4 reboots to figure the offending patch using git-bisect - could you 
> please give it a try?

I applied all of the 2.6.21-rc2-rc3 incremental patch except for the
portion applicable to "drivers/ide" files.  The problem seems to be
elsewhere: 2.6.21-rc3 minus the drivers/ide changes still hangs at the
same spot during the boot process.

Any ideas where to look next?  Thanks!

-- 
-----------------------------------------------------------------------
Bob Tracy                   WTO + WIPO = DMCA? http://www.anti-dmca.org
rct@frus.com
-----------------------------------------------------------------------
