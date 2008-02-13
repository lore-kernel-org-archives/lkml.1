Return-Path: <linux-kernel-owner+w=401wt.eu-S933813AbYBMRPE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933813AbYBMRPE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 12:15:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761735AbYBMROr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 12:14:47 -0500
Received: from gherkin.frus.com ([192.158.254.49]:60744 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764705AbYBMROq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 12:14:46 -0500
Subject: Re: [REGRESSION] 2.6.25-rc1 does not boot on Alpha
In-Reply-To: <20080213155713.GA376@jurassic.park.msu.ru> "from Ivan Kokshaysky
 at Feb 13, 2008 06:57:13 pm"
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Date: Wed, 13 Feb 2008 11:14:43 -0600 (CST)
CC: Ingo Molnar <mingo@elte.hu>, Bob Tracy <rct@frus.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
X-Mailer: ELM [version 2.4ME+ PL82 (25)]
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Message-Id: <20080213171443.80C8BDBA2@gherkin.frus.com>
From: rct@frus.com (Bob Tracy)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ivan Kokshaysky wrote:
> No SMP, no PRINTK_TIMESTAMPS in my case. Looks like it dies trying to
> to switch to vga console, but I had no time to debug this yet...

Same basic configuration as Ivan.  Concur with the observation that
death seems to happen during the console switch.  Using the radeonfb
driver (built-in, default graphics mode 80x30).

-- 
------------------------------------------------------------------------
Bob Tracy          |  "I was a beta tester for dirt.  They never did
rct@frus.com       |   get all the bugs out." - Steve McGrew on /.
------------------------------------------------------------------------
