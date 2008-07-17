Return-Path: <linux-kernel-owner+w=401wt.eu-S932170AbYGQWXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932170AbYGQWXS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 18:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757157AbYGQWXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 18:23:07 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:20686 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756220AbYGQWXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 18:23:06 -0400
Date: Thu, 17 Jul 2008 15:21:31 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for July 17 (sysctl/syscall)
Message-Id: <20080717152131.13ada1fc.randy.dunlap@oracle.com>
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


Who is making patches to kernel/sysctl.c ?

With
CONFIG_SYSCTL=y
# CONFIG_SYSCTL_SYSCALL is not set

linux-next-20080717 produces:

linux-next-20080717/kernel/sysctl.c:2970: error: redefinition of 'setup_sysctl_set'
linux-next-20080717/kernel/sysctl.c:1963: error: previous definition of 'setup_sysctl_set' was here

because one definition of it is bounded by CONFIG_SYSCTL and another definition
of it is bounded by CONFIG_SYSCTL_SYSCALL... :(


---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
