Return-Path: <linux-kernel-owner+w=401wt.eu-S1756619AbYDXLkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756619AbYDXLkh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 07:40:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751727AbYDXLk0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 07:40:26 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:57174 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585AbYDXLkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 07:40:25 -0400
Message-Id: <20080424113950.818688067@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 24 Apr 2008 13:39:50 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@zeniv.linux.org.uk
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       dave@linux.vnet.ibm.com, ezk@cs.sunysb.edu, mhalcrow@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 00/13] vfs: add helpers to check r/o bind mounts
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patches 1-3 are cleanups/bugfixes preceding the main series.  The
description is in 4/13.  This is against latest git.

<rant>

R/O bind mounts patches have been reviewed numerous times.  Still a
relatively large number of places remained where checking for R/O
mounts was missed.

Then I did this series, which basically guarantees, that that cannot
happen.  Al rejected it, and rather fixed some of the remaining
places.  He still missed several, which sort of proves my point.

I think it's totally pointless to continue trying to fix the symptoms
instead of getting at the root of the problem.

I know that VFS interfaces are a sensitive question, but it would be
nice it we could have some sanity back in this discussion.

</rant>

Thanks,
Miklos

--
