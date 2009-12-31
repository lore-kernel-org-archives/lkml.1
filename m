Return-Path: <linux-kernel-owner+w=401wt.eu-S1753138AbZLaTIw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138AbZLaTIw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 14:08:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753119AbZLaTIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 14:08:51 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:20517 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038AbZLaTIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 14:08:50 -0500
Date: Thu, 31 Dec 2009 11:07:47 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
       Jason Wessel <jason.wessel@windriver.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       kgdb-bugreport@lists.sourceforge.net
Subject: Re: linux-next: Tree for December 31 (kgdb)
Message-Id: <20091231110747.5efc1efa.randy.dunlap@oracle.com>
In-Reply-To: <20091231112314.a51e160b.sfr@canb.auug.org.au>
References: <20091231112314.a51e160b.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt358.oracle.com [141.146.40.158]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4B3CF6A8.023F:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Dec 2009 11:23:14 +1100 Stephen Rothwell wrote:

> Hi all,
> 
> This one has also not had the build testing *between* merges, but has had
> all the normal build testing at the end.There may be more unbisectable
> points in the tree then usual.
> 
> Changes since 20091230:
> 
> My fixes tree is again empty with the equivalent of its patch being added
> to Linus' tree.


when CONFIG_PROC_FS is not enabled:

kernel/built-in.o: In function `kdb_summary':
kdb_main.c:(.text+0x6a413): undefined reference to `_meminfo_proc_show'


when CONFIG_KGDB_KDB is not enabled:

kernel/built-in.o: In function `kdb_dmesg':
kdb_main.c:(.text+0x6b5c4): undefined reference to `kdb_syslog_data'

when CONFIG_KDB_KEYBOARD is not enabled:

drivers/built-in.o: In function `cleanup_kgdboc':
kgdboc.c:(.text+0x1ee2df): undefined reference to `kdb_get_kbd_char'
drivers/built-in.o: In function `configure_kgdboc':
kgdboc.c:(.text+0x1ee463): undefined reference to `kdb_get_kbd_char'



---
~Randy
