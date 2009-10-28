Return-Path: <linux-kernel-owner+w=401wt.eu-S1753805AbZJ1RSM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805AbZJ1RSM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 13:18:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752929AbZJ1RSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 13:18:12 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:33408 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752790AbZJ1RSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 13:18:11 -0400
Subject: [PATCH 0/3] More kmemleak patches for 2.6.33
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Wed, 28 Oct 2009 17:18:15 +0000
Message-ID: <20091028171426.19220.658.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.15-1-g9f9ed
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Oct 2009 17:18:15.0618 (UTC) FILETIME=[A2A93220:01CA57F2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are some more kmemleak improvement patches which I intend to push
during the upcoming merging window.


Catalin Marinas (3):
      kmemleak: Release the object lock before calling put_object()
      kmemleak: Show the age of an unreferenced object
      kmemleak: Reduce the false positives by checking for modified objects


 mm/kmemleak.c |  139 +++++++++++++++++++++++++++++++++------------------------
 1 files changed, 80 insertions(+), 59 deletions(-)

-- 
Catalin
