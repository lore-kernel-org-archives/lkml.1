Return-Path: <linux-kernel-owner+w=401wt.eu-S1753463AbZIWAKK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463AbZIWAKK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 20:10:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752542AbZIWAKJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 20:10:09 -0400
Received: from gir.skynet.ie ([193.1.99.77]:41931 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753112AbZIWAKJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 20:10:09 -0400
Date: Wed, 23 Sep 2009 01:10:15 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org, mingo@elte.hu
cc: linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org
Subject: [git pull] vga arb build fix.
Message-ID: <alpine.DEB.2.00.0909230109160.7108@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Please pull the 'vgaarb-fix' branch from
ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git vgaarb-fix

this just fixes the build when DRM is on but VGA arb is off.

Dave.

 include/linux/vgaarb.h |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

commit 7c329288d72e025db4feac65f0fed95fb3e3ef1c
Author: Ingo Molnar <mingo@elte.hu>
Date:   Wed Sep 23 09:52:18 2009 +1000

    vgaarb: make client interface config invariant.
    
    Fixes build when VGA_ARB is off.
    
    Reported-by: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Dave Airlie <airlied@redhat.com>
