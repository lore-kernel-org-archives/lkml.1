Return-Path: <linux-kernel-owner+w=401wt.eu-S1754837AbYENVR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837AbYENVR6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 17:17:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751996AbYENVRq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 17:17:46 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:55879 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598AbYENVRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 17:17:45 -0400
Date: Wed, 14 May 2008 14:16:30 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ericvh@gmail.com,
       v9fs-developer@lists.sourceforge.net
Subject: Re: 2.6.26-rc2-mm1 (p9 build error when 9P_FS=n)
Message-Id: <20080514141630.bcf8d0cd.randy.dunlap@oracle.com>
In-Reply-To: <20080514010129.4f672378.akpm@linux-foundation.org>
References: <20080514010129.4f672378.akpm@linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
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

On Wed, 14 May 2008 01:01:29 -0700 Andrew Morton wrote:

> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.26-rc2/2.6.26-rc2-mm1/

net/built-in.o: In function `init_p9':
mod.c:(.init.text+0x4b0d): undefined reference to `p9_trans_fd_init'
make[1]: *** [.tmp_vmlinux1] Error 1


CONFIG_NET_9P=y
CONFIG_NET_9P_FD=m
CONFIG_NET_9P_VIRTIO=m
CONFIG_NET_9P_DEBUG=y

# CONFIG_9P_FS is not set


---
~Randy
