Return-Path: <linux-kernel-owner+w=401wt.eu-S1753837Ab0AaTiO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837Ab0AaTiO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 14:38:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751623Ab0AaTiN
	(ORCPT <rfc822;linux-kernel-outgoing-6734>);
	Sun, 31 Jan 2010 14:38:13 -0500
Received: from qw-out-2122.google.com ([74.125.92.26]:16174 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932115Ab0AaTiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 14:38:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=jxhfDaTHKaj8yXkWVSb2XwfRrVtlmaNZzLlySDbFiflW4yzTODcKFuPz4wWFRpfoPh
         f9jc46/0FNL5zCoKpb0CG8CB4FKnyz3f6X29K+emDgMR1NO2I9EzlrSxd1yBvOiyQllN
         RkoGmtcb241cwwU1ChhdJxr5+aNS8OGClNj1k=
From: John Kacur <jkacur@redhat.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Dan Nicholson <dbn.lists@gmail.com>, Dave Airlie <airlied@linux.ie>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jerome Glisse <jglisse@redhat.com>,
       Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
       dri-devel <dri-devel@lists.sf.net>,
       Alex Deucher <alexdeucher@gmail.com>,
       Kevin Winchester <kjwinchester@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, John Kacur <jkacur@redhat.com>
Subject: [PATCH 0/2] radeon_agp_init fixes
Date: Sun, 31 Jan 2010 20:38:01 +0100
Message-Id: <1264966683-17992-1-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

radeon_agp_init fixes:

John Kacur (2):

  radeon_agp: Fix warning, format ‘%d’ expects type ‘int’, but argument
    4 has type ‘size_t’. Also fix grammar/spelling error, change "to" to "too"

  radeon_agp: Move the check of the aper_size after drm_acp_acquire and
    drm_agp_info

 drivers/gpu/drm/radeon/radeon_agp.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

