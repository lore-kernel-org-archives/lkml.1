Return-Path: <linux-kernel-owner+w=401wt.eu-S1761086AbXI1Bk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761086AbXI1Bk1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 21:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760065AbXI1BkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 21:40:13 -0400
Received: from gate.crashing.org ([63.228.1.57]:36976 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757568AbXI1BkM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 21:40:12 -0400
Subject: iwl4965 and driver merging policy
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@osdl.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       tomas.winkler@intel.com
Content-Type: text/plain
Date: Fri, 28 Sep 2007 11:39:27 +1000
Message-Id: <1190943567.6158.50.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi !

Just a little question in the light of the discussion we had at Kernel
Summit about merging drivers upstream (and here, I strongly agree with
Linus, hence my message).

I just got that new T61 laptop which happens to have an iwl4xxx chip.
The distro I installed on it (ubuntu) has a driver for it. I suspect
others do too and most users get it from some random external tree and
use it.

Thus my question, why are we about to release 2.6.23 without it ?

It doesn't seem to pull any depedency nor affect any other external
piece of code unless I'm missing something, so it's a perfect example of
what we've been discussing back then: there is just no point not merging
it at any time right ? :-)

Cheers,
Ben.


