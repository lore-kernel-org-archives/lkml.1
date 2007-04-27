Return-Path: <linux-kernel-owner+w=401wt.eu-S1755735AbXD0MMk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755735AbXD0MMk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 08:12:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755737AbXD0MMi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 08:12:38 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:55121 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755731AbXD0MMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 08:12:31 -0400
Message-Id: <20070427120417.110164241@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Fri, 27 Apr 2007 14:04:17 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org, serue@us.ibm.com, viro@ftp.linux.org.uk,
       linuxram@us.ibm.com, ebiederm@xmission.com, kzak@redhat.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org
Subject: [patch 00/10]  mount ownership and unprivileged mount syscall (v5)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

v4 -> v5:

 - fold back Andrew's changes
 - fold back my update patch:
    o use fsuid instead of ruid
    o allow forced unpriv. unmounts for "safe" filesystems
    o allow mounting over special files, but not over symlinks
    o set nosuid and nodev based on lack of specific capability
 - patch header updates
 - new patch: on propagation inherit owner from parent
 - new patch: add "no submounts" mount flag

The last two patches are up for discussion.

The rest I think is in pretty good shape for merging.  If somebody
feels otherwise, please complain now.

--
