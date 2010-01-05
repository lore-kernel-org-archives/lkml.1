Return-Path: <linux-kernel-owner+w=401wt.eu-S1754109Ab0AEBo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109Ab0AEBo2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 20:44:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754050Ab0AEBoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 20:44:25 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:17431 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754047Ab0AEBoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 20:44:23 -0500
Date: Mon, 4 Jan 2010 17:38:23 -0800
From: Joel Becker <Joel.Becker@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Fasheh <mfasheh@suse.com>, Sunil Mushran <sunil.mushran@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       ocfs2-devel@oss.oracle.com
Subject: [GIT PULL] ocfs2 update for 2.6.33
Message-ID: <20100105013823.GD19331@mail.oracle.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	Mark Fasheh <mfasheh@suse.com>,
	Sunil Mushran <sunil.mushran@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4B42996A.00A8:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Linus,
	Here's the one fix that conflicted against master.  I rebased it
atop master and let it stew in linux-next for a little bit.  It's an
important fix, getting O_DIRECT correct as we CoW a refcounted cluster.
	Please pull.

Joel

The following changes since commit 6b7b284958d47b77d06745b36bc7f36dab769d9b:
  Linus Torvalds (1):
        Linux 2.6.33-rc2

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jlbec/ocfs2 upstream-linus

Tao Ma (1):
      ocfs2: Handle O_DIRECT when writing to a refcounted cluster.

 fs/ocfs2/file.c |   21 +++++++++++++++------
 1 files changed, 15 insertions(+), 6 deletions(-)
-- 

"Every day I get up and look through the Forbes list of the richest
 people in America. If I'm not there, I go to work."
        - Robert Orben

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
http://oss.oracle.com/mailman/listinfo/ocfs2-devel
