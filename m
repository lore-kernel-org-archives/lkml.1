Return-Path: <linux-kernel-owner+w=401wt.eu-S1754181AbZGAVIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181AbZGAVIT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 17:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753320AbZGAVIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 17:08:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40116 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751046AbZGAVIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 17:08:11 -0400
Date: Wed, 1 Jul 2009 14:07:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@linux-foundation.org, dwmw2@infradead.org,
       linux-kernel@vger.kernel.org, dhowells@redhat.com
Subject: Re: [PATCH] FRV: Fix a warning due to an unnecessary #include of an
 MTD header
Message-Id: <20090701140705.46481737.akpm@linux-foundation.org>
In-Reply-To: <20090630212425.19244.37019.stgit@warthog.procyon.org.uk>
References: <20090630212425.19244.37019.stgit@warthog.procyon.org.uk>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jun 2009 22:24:25 +0100
David Howells <dhowells@redhat.com> wrote:

> Fix a warning due to an unnecessary #inclusion of linux/mtd/partitions:
> 
>   CC      arch/frv/mb93090-mb00/flash.o
> In file included from arch/frv/mb93090-mb00/flash.c:15:
> include/linux/mtd/partitions.h:50: warning: 'struct mtd_info' declared inside parameter list
> include/linux/mtd/partitions.h:50: warning: its scope is only this definition or declaration, which is probably not what you want
> include/linux/mtd/partitions.h:51: warning: 'struct mtd_info' declared inside parameter list
> include/linux/mtd/partitions.h:61: warning: 'struct mtd_info' declared inside parameter list
> include/linux/mtd/partitions.h:67: warning: 'struct mtd_info' declared inside parameter list

hm.  Maybe fix include/linux/mtd/partitions.h?

>  arch/frv/mb93090-mb00/flash.c |    1 -

That file isn't in mainline or linux-next afacit.
