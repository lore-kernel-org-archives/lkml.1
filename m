Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932280Ab0CNKsN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 06:48:13 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:48082 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932072Ab0CNKsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 06:48:12 -0400
Message-ID: <4B9CBEE6.1090509@in.ibm.com>
Date: Sun, 14 Mar 2010 16:18:06 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: Linux/PPC Development <linuxppc-dev@ozlabs.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, nishimura@mxp.nes.nec.co.jp,
       lizf@cn.fujitsu.com
Subject: 34-rc1-git3 build failure with CGROUP_MEM_RES_CTLR_SWAP=y
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On a PowerPC box, latest 34-rc1 git(d89b218b8...) fails to build
with CGROUPS_MEM_RES_CTRL_SWAP=y. 

LD      init/built-in.o
LD      .tmp_vmlinux1
mm/built-in.o: In function __xchg:
arch/powerpc/include/asm/system.h:331: undefined reference to .__xchg_called_with_bad_pointer
mm/built-in.o: In function __cmpxchg:
arch/powerpc/include/asm/system.h:474: undefined reference to .__cmpxchg_called_with_bad_pointer
make: *** [.tmp_vmlinux1] Error 1

The code in question was added via commit 024914477e...

memcg: move charges of anonymous swap

Thanks
-Sachin


-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

