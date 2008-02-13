Return-Path: <linux-kernel-owner+w=401wt.eu-S933665AbYBMWEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933665AbYBMWEo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 17:04:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935047AbYBMVwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 16:52:35 -0500
Received: from gherkin.frus.com ([192.158.254.49]:38029 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935039AbYBMVwd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 16:52:33 -0500
Subject: Re: [REGRESSION] 2.6.25-rc1 does not boot on Alpha
In-Reply-To: <20080213212422.GB2853@jurassic.park.msu.ru> "from Ivan Kokshaysky
 at Feb 14, 2008 00:24:22 am"
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Date: Wed, 13 Feb 2008 15:52:31 -0600 (CST)
CC: Bob Tracy <rct@frus.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
X-Mailer: ELM [version 2.4ME+ PL82 (25)]
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Message-Id: <20080213215231.3B05DDBA2@gherkin.frus.com>
From: rct@frus.com (Bob Tracy)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ivan Kokshaysky wrote:
> On Wed, Feb 13, 2008 at 11:14:43AM -0600, Bob Tracy wrote:
> > Ivan Kokshaysky wrote:
> > > No SMP, no PRINTK_TIMESTAMPS in my case. Looks like it dies trying to
> > > to switch to vga console, but I had no time to debug this yet...
> > 
> > Same basic configuration as Ivan.  Concur with the observation that
> > death seems to happen during the console switch.  Using the radeonfb
> > driver (built-in, default graphics mode 80x30).
> 
> As Peter pointed out in other mail, this is fixed by
> 
> http://lkml.org/lkml/2008/1/28/100

ACK.  I'll confirm it works for me this evening.  Good catch, all.

-- 
------------------------------------------------------------------------
Bob Tracy          |  "I was a beta tester for dirt.  They never did
rct@frus.com       |   get all the bugs out." - Steve McGrew on /.
------------------------------------------------------------------------
