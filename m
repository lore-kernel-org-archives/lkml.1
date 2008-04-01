Return-Path: <linux-kernel-owner+w=401wt.eu-S1758578AbYDAQV7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758578AbYDAQV7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 12:21:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754717AbYDAQVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 12:21:51 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:25475 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754432AbYDAQVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 12:21:50 -0400
Date: Tue, 1 Apr 2008 09:21:19 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, mb@bu3sch.de
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for April 1 (ssb build error)
Message-Id: <20080401092119.3cb214b1.randy.dunlap@oracle.com>
In-Reply-To: <20080401175230.9ffe75cf.sfr@canb.auug.org.au>
References: <20080401175230.9ffe75cf.sfr@canb.auug.org.au>
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

On Tue, 1 Apr 2008 17:52:30 +1100 Stephen Rothwell wrote:

> Hi all,
> 
> I have created today's linux-next tree at
> git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git
> (tar balls at
> http://www.kernel.org/pub/linux/kernel/people/sfr/linux-next/).

ssb build fails when SSB_PCIHOST is not set, as in:

CONFIG_SSB_POSSIBLE=y
CONFIG_SSB=y
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
# CONFIG_SSB_PCIHOST is not set
CONFIG_SSB_PCMCIAHOST_POSSIBLE=y
CONFIG_SSB_PCMCIAHOST=y
CONFIG_SSB_DEBUG=y

Error is:

drivers/built-in.o: In function `ssb_attr_sprom_store':
(.text+0x1c4b79): undefined reference to `ssb_devices_freeze'
drivers/built-in.o: In function `ssb_attr_sprom_store':
(.text+0x1c4bb3): undefined reference to `ssb_devices_thaw'
make[1]: *** [.tmp_vmlinux1] Error 1

---
~Randy
