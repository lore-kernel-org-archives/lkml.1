Return-Path: <linux-kernel-owner+w=401wt.eu-S1758877AbXFBASE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758877AbXFBASE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 20:18:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757446AbXFBARv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 20:17:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:59696 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754141AbXFBARu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 20:17:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,374,1175497200"; 
   d="scan'208";a="92767893"
From: Dan Williams <dan.j.williams@intel.com>
Subject: [RFC PATCH 0/2] dmaengine: preparation for raid acceleration
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       christopher.leech@intel.com
Date: Fri, 01 Jun 2007 17:17:49 -0700
Message-ID: <20070602001527.1707.58092.stgit@dwillia2-linux.ch.intel.com>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello David,

The following two patches are part of the raid acceleration series I
would like to push for 2.6.23 consideration.  I am sending these two
separately for your review for the following reasons: the 'dmaengine'
core initially came in through netdev,  patch #2 makes changes to
net/dev/core.c, and lastly I have an ack on the raid changes but no ack
from the community on the i/oat and dmaengine changes.

      dmaengine: add base support for the async_tx api
      dmaengine: move channel management to the client

Regards,
Dan

the full series is available at:
git://lost.foo-projects.org/~dwillia2/git/iop md-accel-linus
 
