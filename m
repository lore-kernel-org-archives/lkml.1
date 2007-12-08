Return-Path: <linux-kernel-owner+w=401wt.eu-S1755978AbXLHExu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978AbXLHExu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 23:53:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753026AbXLHExl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 23:53:41 -0500
Received: from gherkin.frus.com ([192.158.254.49]:40798 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751935AbXLHExk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 23:53:40 -0500
Subject: Re: [BUG] 2.6.23-rc3 can't see sd partitions on Alpha
In-Reply-To: <1197062383.5483.46.camel@lov.site> "from Kay Sievers at Dec 7,
 2007 10:19:43 pm"
To: Kay Sievers <kay.sievers@vrfy.org>
Date: Fri, 7 Dec 2007 22:53:25 -0600 (CST)
CC: Michael Cree <mcree@orcon.net.nz>, Bob Tracy <rct@frus.com>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, rjw@sisk.pl, rth@twiddle.net,
       ink@jurassic.park.msu.ru, linux-scsi@vger.kernel.org, greg@kroah.com
X-Mailer: ELM [version 2.4ME+ PL82 (25)]
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Message-Id: <20071208045325.7C8F1DBA2@gherkin.frus.com>
From: rct@frus.com (Bob Tracy)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers wrote:
> Is the udev daemon (still) running while it fails?

Yes.

> If you run /sbin/udevtrigger, do the nodes appear?

No.  Exit status is 0, and there are no errors.  Everything looks
fine under /sys/block, and there doesn't seem to be a problem with
/proc/devices either.

-- 
------------------------------------------------------------------------
Bob Tracy          |  "They couldn't hit an elephant at this dist- "
rct@frus.com       |   - Last words of Union General John Sedgwick,
                   |  Battle of Spotsylvania Court House, U.S. Civil War
------------------------------------------------------------------------
