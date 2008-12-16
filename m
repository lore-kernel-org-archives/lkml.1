Return-Path: <linux-kernel-owner+w=401wt.eu-S1754002AbYLPD4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002AbYLPD4W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 22:56:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751086AbYLPD4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 22:56:13 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:19195 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbYLPD4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 22:56:13 -0500
Message-ID: <494726DE.6000100@oracle.com>
Date: Mon, 15 Dec 2008 19:56:14 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: akpm <akpm@linux-foundation.org>
Subject: Re: mmotm 2008-12-15-16-45 uploaded (build errors)
References: <200812160046.mBG0k0YV024823@imap1.linux-foundation.org>
In-Reply-To: <200812160046.mBG0k0YV024823@imap1.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt705.oracle.com [141.146.40.83]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A09020A.494726D0.014C:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

akpm@linux-foundation.org wrote:
> The mm-of-the-moment snapshot 2008-12-15-16-45 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/
> 
> It contains the following patches against 2.6.28-rc8:


Summary of build errors:

i386
=====
build-r7178.out:/local/linsrc/tmp/mmotm-2008-1215-1645/mm/vmscan.c:1397: error: too few arguments to function 'mem_cgroup_inactive_anon_is_low'
build-r7178.out:make[2]: *** [mm/vmscan.o] Error 1
build-r7178.out:/local/linsrc/tmp/mmotm-2008-1215-1645/fs/fuse/file.c:792: error : implicit declaration of function '__grab_cache_page'
build-r7178.out:make[3]: *** [fs/fuse/file.o] Error 1
7188	same
7190	same
7195	same

build-r7179.out:/local/linsrc/tmp/mmotm-2008-1215-1645/fs/fuse/file.c:792: error : implicit declaration of function '__grab_cache_page'
build-r7179.out:make[3]: *** [fs/fuse/file.o] Error 1
7180	same

build-r7181.out:/local/linsrc/tmp/mmotm-2008-1215-1645/fs/reiser4/plugin/file/file_conversion.c:689: error: implicit declaration of function '__grab_cache_page'
build-r7181.out:make[3]: *** [fs/reiser4/plugin/file/file_conversion.o] Error 1


x86_64
=====
build-r7182.out:/local/linsrc/tmp/mmotm-2008-1215-1645/mm/vmscan.c:1397: error: too few arguments to function 'mem_cgroup_inactive_anon_is_low'
build-r7182.out:make[2]: *** [mm/vmscan.o] Error 1
build-r7182.out:/local/linsrc/tmp/mmotm-2008-1215-1645/fs/fuse/file.c:792: error : implicit declaration of function '__grab_cache_page'
build-r7182.out:make[3]: *** [fs/fuse/file.o] Error 1
7185	same
7189	same
7191	same

build-r7183.out:/local/linsrc/tmp/mmotm-2008-1215-1645/mm/vmscan.c:1397: error: too few arguments to function 'mem_cgroup_inactive_anon_is_low'
build-r7183.out:make[2]: *** [mm/vmscan.o] Error 1
build-r7183.out:/local/linsrc/tmp/mmotm-2008-1215-1645/fs/reiser4/plugin/file/fi le_conversion.c:689: error: implicit declaration of function '__grab_cache_page'
build-r7183.out:make[3]: *** [fs/reiser4/plugin/file/file_conversion.o] Error 1

build-r7184.out:/local/linsrc/tmp/mmotm-2008-1215-1645/fs/ubifs/file.c:251: error: 'flags' undeclared (first use in this function)
build-r7184.out:make[3]: *** [fs/ubifs/file.o] Error 1


~Randy
(need .config files?)

