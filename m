Return-Path: <linux-kernel-owner+w=401wt.eu-S1754410AbYFRTMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754410AbYFRTMR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 15:12:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750817AbYFRTMF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 15:12:05 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:14313 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbYFRTME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 15:12:04 -0400
Date: Wed, 18 Jun 2008 12:12:14 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Soumyadip Das Mahapatra <kernelhacker@visualserver.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Significance Of sort() In include/linux/sort.h
Message-Id: <20080618121214.ceb6b5d7.randy.dunlap@oracle.com>
In-Reply-To: <Pine.LNX.4.64.0806152126001.6721@visualserver.org>
References: <Pine.LNX.4.64.0806152126001.6721@visualserver.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jun 2008 20:39:38 +0200 (CEST) Soumyadip Das Mahapatra wrote:

> Hello everybody,
>  	I dont understand what is the significance of keeping
> include/linux/sort.h and lib/sort.c while i think there is
> none using (#include<linux/sort.h>) it. Can anyone explaint it?

Did you check all of these?

./drivers/message/fusion/mptfc.c:56:#include <linux/sort.h>
./drivers/net/pppol2tp.c:92:#include <linux/sort.h>
./drivers/media/video/saa7134/saa7134-video.c:28:#include <linux/sort.h>
./drivers/media/video/v4l2-int-device.c:27:#include <linux/sort.h>
./fs/gfs2/glock.c:16:#include <linux/sort.h>
./fs/gfs2/dir.c:59:#include <linux/sort.h>
./fs/gfs2/quota.c:44:#include <linux/sort.h>
./fs/gfs2/inode.c:16:#include <linux/sort.h>
./fs/ubifs/find.c:29:#include <linux/sort.h>
./fs/nfs_common/nfsacl.c:28:#include <linux/sort.h>
./lib/extable.c:14:#include <linux/sort.h>
./arch/sparc/prom/memory.c:9:#include <linux/sort.h>
./arch/x86/kernel/test_nx.c:13:#include <linux/sort.h>
./arch/x86/kernel/mmconf-fam10h_64.c:11:#include <linux/sort.h>
./arch/x86/kernel/setup_64.c:44:#include <linux/sort.h>
./arch/x86/kernel/cpu/mtrr/main.c:40:#include <linux/sort.h>
./arch/sparc64/mm/init.c:25:#include <linux/sort.h>
./arch/powerpc/kernel/module_64.c:27:#include <linux/sort.h>
./arch/powerpc/kernel/module_32.c:27:#include <linux/sort.h>
./arch/ia64/mm/extable.c:8:#include <linux/sort.h>
./kernel/lockdep_proc.c:20:#include <linux/sort.h>
./kernel/cpuset.c:52:#include <linux/sort.h>
./kernel/cgroup.c:43:#include <linux/sort.h>
./mm/page_alloc.c:42:#include <linux/sort.h>

---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
