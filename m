Return-Path: <linux-kernel-owner+w=401wt.eu-S1753941AbYCLRcg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941AbYCLRcg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 13:32:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751259AbYCLRcV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 13:32:21 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:21479 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbYCLRcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 13:32:21 -0400
Message-Id: <20080312173155.703966894@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Wed, 12 Mar 2008 18:31:55 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [patch 00/10] System z10 patches.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,
two weeks ago System z10 has been announced. This patchset adds support
for some of the new features of this machine. The two main features
are large page support (1MB pages) and cpu topology supporty. There are
some common code dependencies for these two, see patches #3, #4, #5, #8
and #9. Most notably we found that we need to add a new tlb flush for the
copy-on-write of a large page (patch #8). We think that this is a bug,
but obviously one that hasn't shown up so far on any of the other large
page architectures.

The patches are queued in the features/for-andrew branches of git390 and
will be included linux-next and -mm (keeping fingers crossed that we
don't create any rejects).

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

