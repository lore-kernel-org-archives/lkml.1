Return-Path: <linux-kernel-owner+w=401wt.eu-S932404AbYGQWei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932404AbYGQWei (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 18:34:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757296AbYGQWe1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 18:34:27 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:18432 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753981AbYGQWe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 18:34:27 -0400
Date: Thu, 17 Jul 2008 15:34:00 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for July 17 (net_namespace)
Message-Id: <20080717153400.e9ef066a.randy.dunlap@oracle.com>
In-Reply-To: <20080718012842.690b8346.sfr@canb.auug.org.au>
References: <20080718012842.690b8346.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
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

With PROC_FS=n, PROC_SYSCTL=n, SYSCTL_SYSCALL=n, the <sysctls> field of
struct net in include/net/net_namespace.h has problems:


In file included from /local/linsrc/linux-next-20080717/include/linux/init_task.h:12,
                 from /local/linsrc/linux-next-20080717/kernel/pid.c:37:
/local/linsrc/linux-next-20080717/include/net/net_namespace.h:40: error: field 'sysctls' has incomplete type


In file included from /local/linsrc/linux-next-20080717/include/linux/netdevice.h:44,
                 from /local/linsrc/linux-next-20080717/include/linux/if_bridge.h:105,
                 from /local/linsrc/linux-next-20080717/fs/compat_ioctl.c:24:
/local/linsrc/linux-next-20080717/include/net/net_namespace.h:40: error: field 'sysctls' has incomplete type


In file included from /local/linsrc/linux-next-20080717/include/linux/init_task.h:12,
                 from /local/linsrc/linux-next-20080717/arch/x86/kernel/init_task.c:5:
/local/linsrc/linux-next-20080717/include/net/net_namespace.h:40: error: field 'sysctls' has incomplete type



---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
