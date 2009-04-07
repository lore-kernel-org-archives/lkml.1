Return-Path: <linux-kernel-owner+w=401wt.eu-S1759738AbZDGF3b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759738AbZDGF3b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 01:29:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759397AbZDGF2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 01:28:53 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54684 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758318AbZDGF2R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 01:28:17 -0400
Message-ID: <49DAE48D.3070408@cn.fujitsu.com>
Date: Tue, 07 Apr 2009 13:28:45 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Li Xiaodong <lixd@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>, linux-net@vger.kernel.org
Subject: [PATCH] Documentation/sysctl/net.txt: fix a typo
References: <1238493359-22157-1-git-send-email-lixd@cn.fujitsu.com> <49D40D67.9020909@cn.fujitsu.com>
In-Reply-To: <49D40D67.9020909@cn.fujitsu.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan wrote:
>> -There are  only  two  files  in this subdirectory. They control the delays for
>> -deleting and destroying socket descriptors.
>> +There is only one file in this directory.
>> +unix_dgram_qlen limits the max number of datagrams queued in Unix domain
>> +socket's buffer. It will not take effect unless PF_UNIX flag is spicified.
>>  
> 
> s/spicified/specified
> 

sigh..This slipped into mainline..let's fix it.


================


s/spicified/specified

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 Documentation/sysctl/net.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/sysctl/net.txt b/Documentation/sysctl/net.txt
index a34d55b..df38ef0 100644
--- a/Documentation/sysctl/net.txt
+++ b/Documentation/sysctl/net.txt
@@ -95,7 +95,7 @@ of struct cmsghdr structures with appended data.
 
 There is only one file in this directory.
 unix_dgram_qlen limits the max number of datagrams queued in Unix domain
-socket's buffer. It will not take effect unless PF_UNIX flag is spicified.
+socket's buffer. It will not take effect unless PF_UNIX flag is specified.
 
 
 3. /proc/sys/net/ipv4 - IPV4 settings
-- 
1.5.4.rc3


