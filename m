Return-Path: <linux-kernel-owner+w=401wt.eu-S1757768AbZKSAlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757768AbZKSAlV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 19:41:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756972AbZKSAlV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 19:41:21 -0500
Received: from gir.skynet.ie ([193.1.99.77]:57625 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756402AbZKSAlU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 19:41:20 -0500
Date: Thu, 19 Nov 2009 00:41:23 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org
Subject: [git pull] agp regression fix
Message-ID: <alpine.DEB.2.00.0911190039080.20033@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Please pull the 'agp-fixes' branch from
ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/agp-2.6.git agp-fixes

This should fix a regression reported in bko and tracked down by dwmw2, if 
not it fixes something that is obviously wrong.

Dave.

 drivers/char/agp/intel-agp.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

commit ec402ba97a6479dd80488b4404a73275e894289f
Author: David Woodhouse <dwmw2@infradead.org>
Date:   Wed Nov 18 10:22:46 2009 +0000

    agp/intel-agp: Set dma_mask for capable chipsets before agp_add_bridge()
    
    We should set this before calling agp_add_bridge() so that it's done
    before we map the scratch page too.
    
    This should probably fix the regression reported as k.o. bug #14627.
    
    Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

