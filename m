Return-Path: <linux-kernel-owner+w=401wt.eu-S1754950AbXLHFF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754950AbXLHFF3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 00:05:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751427AbXLHFFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 00:05:21 -0500
Received: from gherkin.frus.com ([192.158.254.49]:40471 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751232AbXLHFFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 00:05:20 -0500
Subject: Re: [BUG] 2.6.23-rc3 can't see sd partitions on Alpha
In-Reply-To: <1197062383.5483.46.camel@lov.site> "from Kay Sievers at Dec 7,
 2007 10:19:43 pm"
To: Kay Sievers <kay.sievers@vrfy.org>
Date: Fri, 7 Dec 2007 23:05:17 -0600 (CST)
CC: Michael Cree <mcree@orcon.net.nz>, Bob Tracy <rct@frus.com>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, rjw@sisk.pl, rth@twiddle.net,
       ink@jurassic.park.msu.ru, linux-scsi@vger.kernel.org, greg@kroah.com
X-Mailer: ELM [version 2.4ME+ PL82 (25)]
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Message-Id: <20071208050517.EC35EDBA2@gherkin.frus.com>
From: rct@frus.com (Bob Tracy)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers wrote:
> Is the udev daemon (still) running while it fails?

Yes, and there's something else I forgot to mention that may be
significant...  For the bad case, in addition to udevd, "ps -ef"
shows a "sh -e /lib/udev/net.agent" running with a PPID of 1.  This
process doesn't exit until I reboot.  If this is normal under the
circumstances, please disregard.

-- 
------------------------------------------------------------------------
Bob Tracy          |  "They couldn't hit an elephant at this dist- "
rct@frus.com       |   - Last words of Union General John Sedgwick,
                   |  Battle of Spotsylvania Court House, U.S. Civil War
------------------------------------------------------------------------
