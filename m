Return-Path: <linux-kernel-owner+w=401wt.eu-S1756835AbYGNJGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835AbYGNJGk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 05:06:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755934AbYGNJGb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 05:06:31 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:47025 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753917AbYGNJGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 05:06:31 -0400
Message-ID: <487B16FB.2040805@oracle.com>
Date: Mon, 14 Jul 2008 17:06:03 +0800
From: Tao Ma <tao.ma@oracle.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: linux-fsdevel@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: Why there is no mutex_lock in vfs_getxattr.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
	When we use vfs_setxattr we call mutex_lock(&inode->i_mutex) to lock 
the inode. Then why there is no mutex_lock in vfs_getxattr? Is there any 
reason for it? And how can I prevent getting the stale xattr if set/get 
happen in the same time?  Just let the actual file system implement it 
by itself?

Regards,
Tao

