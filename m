Return-Path: <linux-kernel-owner+w=401wt.eu-S1760212AbXFER5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760212AbXFER5W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 13:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756033AbXFER5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 13:57:04 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57429 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754939AbXFER5C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 13:57:02 -0400
Date: Tue, 5 Jun 2007 13:56:48 -0400
From: Jeff Layton <jlayton@redhat.com>
To: nfsv4@linux-nfs.org, nfs@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] intro: make NFSv4 exclusive open calls set and use the
 bitmask in the reply
Message-Id: <20070605135648.579e2557.jlayton@redhat.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Around a year ago, Chris Lalancette posted a patch to make it so that
when an EXCLUSIVE nfs4 create is done, that the mtime and atime get
properly updated in the following setattr call. At the time Trond
replied that that approach was incorrect and that we need to check the
bitmask in the reply to know what attributes need to be updated.

The original thread is here:

http://linux-nfs.org/pipermail/nfsv4/2006-June/004489.html

The following patchset is a first stab at making the Linux client and
server adhere to the correct NFS4 exclusive open semantics.

As always, comments are appreciated...
-- 
Jeff Layton <jlayton@redhat.com>
