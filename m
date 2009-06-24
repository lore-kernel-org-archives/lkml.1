Return-Path: <linux-kernel-owner+w=401wt.eu-S1761833AbZFXT6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761833AbZFXT6Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 15:58:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751969AbZFXT6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 15:58:17 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43473 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751485AbZFXT6R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 15:58:17 -0400
Subject: Re: Build failure with v2.6.30-8722-gc82e6d4 on x86_64
From: Eric Paris <eparis@redhat.com>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk
In-Reply-To: <200906242145.39438.elendil@planet.nl>
References: <200906242145.39438.elendil@planet.nl>
Content-Type: text/plain
Date: Wed, 24 Jun 2009 15:57:59 -0400
Message-Id: <1245873479.11046.8.camel@dhcp235-23.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-06-24 at 21:45 +0200, Frans Pop wrote:
> Help!
> 
> Cheers,
> FJP
> 
>   LD      vmlinux.o
>   MODPOST vmlinux.o
>   GEN     .version
>   CHK     include/linux/compile.h
>   UPD     include/linux/compile.h
>   CC      init/version.o
>   LD      init/built-in.o
>   LD      .tmp_vmlinux1
> kernel/built-in.o: In function `audit_compare_rule':
> auditfilter.c:(.text+0x3f1ec): undefined reference to `audit_watch_path'
> auditfilter.c:(.text+0x3f1fc): undefined reference to `audit_watch_path'
> kernel/built-in.o: In function `audit_free_rule':
> auditfilter.c:(.text+0x3f580): undefined reference to `audit_put_watch'
> kernel/built-in.o: In function `audit_data_to_entry':
> auditfilter.c:(.text+0x3f9ad): undefined reference to `audit_to_watch'
> kernel/built-in.o: In function `audit_receive_filter':
> (.text+0x3fde6): undefined reference to `audit_watch_path'
> kernel/built-in.o: In function `audit_receive_filter':
> (.text+0x3ffb7): undefined reference to `audit_add_watch'
> kernel/built-in.o: In function `audit_receive_filter':
> (.text+0x3ffde): undefined reference to `audit_watch_inode'
> kernel/built-in.o: In function `audit_receive_filter':
> (.text+0x40104): undefined reference to `audit_put_watch'
> kernel/built-in.o: In function `audit_receive_filter':
> (.text+0x401bf): undefined reference to `audit_remove_watch_rule'
> kernel/built-in.o: In function `audit_receive_filter':
> (.text+0x4023f): undefined reference to `audit_inotify_unregister'
> kernel/built-in.o: In function `audit_receive_filter':
> (.text+0x4024c): undefined reference to `audit_put_watch'
> kernel/built-in.o: In function `audit_dupe_rule':
> (.text+0x404d1): undefined reference to `audit_get_watch'
> kernel/built-in.o: In function `audit_update_lsm_rules':
> (.text+0x40610): undefined reference to `audit_watch_rules'
> make[5]: *** [.tmp_vmlinux1] Error 1

building with CONFIG_AUDIT_SYSCALL will shut it up.  I'll fix
momentarily.

-Eric

