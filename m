Return-Path: <linux-kernel-owner+w=401wt.eu-S933030AbZHVASi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933030AbZHVASi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 20:18:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932992AbZHVASh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 20:18:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57813 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932991AbZHVASh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 20:18:37 -0400
Date: Fri, 21 Aug 2009 17:17:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, tony.luck@intel.com,
       linux-ia64@vger.kernel.org, nhorman@redhat.com, ebiederm@xmission.com,
       andi@firstfloor.org, mingo@elte.hu, amwang@redhat.com,
       bernhard.walle@gmx.de, fenghua.yu@intel.com,
       kamezawa.hiroyu@jp.fujitsu.com, avorontsov@ru.mvista.com
Subject: Re: [Patch 1/8] kexec: allow to shrink reserved memory
Message-Id: <20090821171738.304fe91e.akpm@linux-foundation.org>
In-Reply-To: <20090821065650.4855.53279.sendpatchset@localhost.localdomain>
References: <20090821065637.4855.32234.sendpatchset@localhost.localdomain>
	<20090821065650.4855.53279.sendpatchset@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Aug 2009 02:54:25 -0400
Amerigo Wang <amwang@redhat.com> wrote:

> +size_t get_crash_memory_size(void)
> +int shrink_crash_memory(unsigned long new_size)

These aren't particualrly well-chosen global identifiers.  It would be
better if they were called crash_*() or kexec_*(), to make it clear
which subsystem they belong to.

