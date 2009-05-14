Return-Path: <linux-kernel-owner+w=401wt.eu-S1756506AbZENJua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756506AbZENJua (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 05:50:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752713AbZENJuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 05:50:20 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:2857 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270AbZENJuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 05:50:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=c+rQXAuGdp+GoNgu/xx416PG9dv89L78kJFnkaTu7/KDg1iuZi1Qj+GiiFdiqxdPsn
         Tb/g2qTHrj+SMOqilZ8kez4WS6DsNbohOIr3aJ3plWuzvilCiI3dLLZ5nRvZyD4z6Ytx
         /w5Y5a3go7KMYkDW8/EtvDsLaoG4LW3YcG4HA=
From: Vitaly Mayatskikh <v.mayatskih@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] More cleanups in do_wait() pathes (V2)
Date: Thu, 14 May 2009 11:50:12 +0200
Message-Id: <1242294612-28680-1-git-send-email-v.mayatskih@gmail.com>
X-Mailer: git-send-email 1.6.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Further cleanups of do_wait() and friends.

Vitaly Mayatskikh (2):
  Completely replace wait_noreap_copyout() by copy_wait_opts_to_user()
  Move more common code from wait_task_*() to copy_wait_opts_to_user()

 kernel/exit.c |   56 ++++++++++++++++++++------------------------------------
 1 files changed, 20 insertions(+), 36 deletions(-)

