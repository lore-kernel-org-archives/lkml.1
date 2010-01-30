Return-Path: <linux-kernel-owner+w=401wt.eu-S1754541Ab0A3UvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541Ab0A3UvT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 15:51:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751808Ab0A3UvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 15:51:17 -0500
Received: from qw-out-2122.google.com ([74.125.92.26]:53614 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400Ab0A3UvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 15:51:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=O6RLtlyVhMlTQx31aD77UVuzZKYu5NQTJRdE402zmm+H1pGdZhMKZq+9xmwnfG0HHF
         ocobw33qDTA01nFF/1W90mBoaxsmJtMSx1S7/63I/MPTjntX5YB3+FnfmFeXdQZ5lrTH
         JVCILeZaCweXA4/yNAr06+pJkBUUYr9Y8YyQc=
From: John Kacur <jkacur@redhat.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
       Kevin Winchester <kjwinchester@gmail.com>,
       Dave Airlie <airlied@linux.ie>, dri-devel <dri-devel@lists.sf.net>,
       Alex Deucher <alexdeucher@gmail.com>,
       Jerome Glisse <jglisse@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       John Kacur <jkacur@redhat.com>
Subject: [PATCH] radeon_agp_init fixes
Date: Sat, 30 Jan 2010 21:51:08 +0100
Message-Id: <1264884670-28211-1-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

radeon_agp_init fixes

John Kacur (2):

  radeon_agp: Fix warning, format ‘%d’ expects type ‘int’, but argument
    4 has type ‘size_t’

  radeon_agp: Move the check of the aper_size after drm_acp_acquire and
    drm_agp_info

 drivers/gpu/drm/radeon/radeon_agp.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

