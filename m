Return-Path: <linux-kernel-owner+w=401wt.eu-S1761397AbXISPxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761397AbXISPxV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 11:53:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752390AbXISPxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 11:53:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35648 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758737AbXISPxJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 11:53:09 -0400
Date: Wed, 19 Sep 2007 11:52:50 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Jeff Layton <jlayton@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org, linux-cifs-client@lists.samba.org,
       nfs@lists.sourceforge.net, ecryptfs-devel@lists.sourceforge.net,
       reiserfs-devel@vger.kernel.org, unionfs@filesystems.org
Subject: Re: [PATCH 0/7] fix setuid/setgid clearing in networked filesystems
 (take 6)
Message-Id: <20070919115250.b55a90cc.jlayton@redhat.com>
In-Reply-To: <200709171129.l8HBT5Kq024360@dantu.rdu.redhat.com>
References: <200709171129.l8HBT5Kq024360@dantu.rdu.redhat.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Sep 2007 07:29:05 -0400
Jeff Layton <jlayton@redhat.com> wrote:

> This patchset is the latest one for fixing the clearing of setuid/setgid
> bits in networked filesystems. It should apply cleanly to 2.6.23-rc4-mm1.
> This is basically the same patchset as take 5. The main differences are
> that the patches have been reordered to make the tree cleanly bisectable,
> and the comment in notify_change is now a bit more descriptive. I've also
> moved the description of the main rationale for the patch into patch 5.
> 
> Andrew, would it be possible to go ahead and get this committed to -mm?
> 
> Signed-off-by: Jeff Layton <jlayton@redhat.com>

Andrew,
  This will need some changes before it can apply cleanly to
2.6.23-rc6-mm1. You can ignore this for now. I'll respin, retest and
repost...

Thanks,
-- 
Jeff Layton <jlayton@redhat.com>
