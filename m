Return-Path: <linux-kernel-owner+w=401wt.eu-S1754940AbYGJEpK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754940AbYGJEpK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 00:45:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752339AbYGJEo7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 00:44:59 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:20645 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233AbYGJEo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 00:44:58 -0400
Date: Wed, 9 Jul 2008 21:44:29 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "K. Ernel" <kernel@wildsau.enemy.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: CONFIG_NETWORK_FILESYSTEMS not set in /proc/config.gz
Message-Id: <20080709214429.63f792d2.randy.dunlap@oracle.com>
In-Reply-To: <200807091622.m69GMjnH025474@wildsau.enemy.org>
References: <200807091622.m69GMjnH025474@wildsau.enemy.org>
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

On Wed, 9 Jul 2008 18:22:45 +0200 (MET DST) K. Ernel wrote:

> 
> hello list,
> 
> I usually switch to a new kernel version using the
> old .config file by doing:
> 
>     # zcat /proc/config.gz > .config
>     # make oldconfig
> 
> however, with the last two (or so) versions, I always lost the network
> file system configuration. It's not present in config.gz,
> while in the old .config of the previous release, it _is_
> present, plus I'm abble to use network file system support
> in the current (before the update) kernel.
> 
> e.g.:
> 
> (1) kernel version:
>     # uname -r
>     2.6.25.9
> 
> (2) this kernel version's configuration in the sources:
>     # grep NETWORK_FILE linux-2.6.25.9/.config
>     CONFIG_NETWORK_FILESYSTEMS=y
> 
> (3) this kernel version's configuration in /proc/config.gz
>     # zcat /proc/config.gz | grep NETWORK_FILE
>     # CONFIG_NETWORK_FILESYSTEMS is not set
> 
> (4) to proof this kernel version has indeed network filesystem:
>     # lsmod| grep nfs
>     nfs                    86896  1 
>     lockd                  38280  2 nfs
>     nfs_acl                 1792  1 nfs
>     sunrpc                101884  10 nfs,lockd,nfs_acl
> 
> 
> to me, this looks like "CONFIG_NETWORK_FILESYSTEMS" is "forgotten" in
> config.gz, but what do I know ...
> 
> please fix if possible,

Hi,

I can't reproduce it on 2.6.25.9 or 2.6.26-rc9.

If there is any more info that you could provide, please do so.
(not that I know what it would be)

---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
