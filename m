Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752685AbYLRR01@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685AbYLRR01 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 12:26:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750872AbYLRR0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 12:26:17 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:47103 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753AbYLRR0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 12:26:16 -0500
Date: Thu, 18 Dec 2008 09:25:57 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, dhowells@redhat.com
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for December 18 (fscache)
Message-Id: <20081218092557.b274e9dd.randy.dunlap@oracle.com>
In-Reply-To: <20081218230637.c879a046.sfr@canb.auug.org.au>
References: <20081218230637.c879a046.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt704.oracle.com [141.146.40.82]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010204.494A87A9.003F:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Dec 2008 23:06:37 +1100 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20081217:
> 
> New tree:
> 	fscache


When CONFIG_BLOCK=n:

build-r7417.out:/local/linsrc/linux-next-20081218/fs/cachefiles/cf-interface.c:357: error: implicit declaration of function 'fsync_super'
build-r7417.out:make[3]: *** [fs/cachefiles/cf-interface.o] Error 1


Should include/linux/buffer_head.h have an empty stub for fsync_super()
or does fscache even make sense when CONFIG_BLOCK=n?

---
~Randy
