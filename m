Return-Path: <linux-kernel-owner+w=401wt.eu-S1752832Ab0AHRZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832Ab0AHRZl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 12:25:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752681Ab0AHRZk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 12:25:40 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:62551 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300Ab0AHRZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 12:25:39 -0500
Date: Fri, 8 Jan 2010 09:25:05 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, netdev@vger.kernel.org
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Arnd Bergmann <arnd@arndb.de>
Subject: Re: linux-next: Tree for January 8 (net/ip.h, BUG=n)
Message-Id: <20100108092505.4f4e1ac3.randy.dunlap@oracle.com>
In-Reply-To: <20100108164232.d3e1a164.sfr@canb.auug.org.au>
References: <20100108164232.d3e1a164.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4B476A88.0243:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Jan 2010 16:42:32 +1100 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20100107:


When CONFIG_BUG=n, CONFIG_GENERIC_BUG=n:

include/net/ip.h:341: error: implicit declaration of function '__WARN'

This affects:
make[3]: *** [security/selinux/hooks.o] Error 1
make[3]: *** [fs/ceph/messenger.o] Error 1
make[3]: *** [net/core/sock.o] Error 1
make[4]: *** [drivers/net/benet/be_main.o] Error 1


(this was on i386 builds)

---
~Randy
