Return-Path: <linux-kernel-owner+w=401wt.eu-S932783AbXA1TqN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932783AbXA1TqN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 14:46:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932755AbXA1TqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 14:46:13 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:62539 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932783AbXA1TqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 14:46:12 -0500
Date: Sun, 28 Jan 2007 11:41:48 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, netfilter@lists.netfilter.org
Subject: Re: 2.6.20-rc6-mm1 (build)
Message-Id: <20070128114148.b8067721.randy.dunlap@oracle.com>
In-Reply-To: <20070127234928.64d8e437.akpm@osdl.org>
References: <20070127234928.64d8e437.akpm@osdl.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.0 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Jan 2007 23:49:28 -0800 Andrew Morton wrote:

> 
> Temporarily at
> 
> 	http://userweb.kernel.org/~akpm/2.6.20-rc6-mm1/
> 
> will appear one day at
> 
> 	ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20-rc6/2.6.20-rc6-mm1/


allyesconfig on x86_64 does not build for me:

drivers/built-in.o: In function `sis_init_one':
sata_sis.c:(.text.sis_init_one+0x1a1): undefined reference to `sis_info133'
sata_sis.c:(.text.sis_init_one+0x1ab): undefined reference to `sis_info133'
net/built-in.o: In function `q931_help':
nf_conntrack_h323_main.c:(.text.q931_help+0x6ad): undefined reference to `ip6_route_output'
nf_conntrack_h323_main.c:(.text.q931_help+0x6c3): undefined reference to `ip6_route_output'

Adrian Bunk has sent a patch for the sis_info133 problem.

---
~Randy
