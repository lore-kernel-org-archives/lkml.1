Return-Path: <linux-kernel-owner+w=401wt.eu-S1754707AbZLCUBb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707AbZLCUBb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 15:01:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753794AbZLCUBa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 15:01:30 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41101 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753613AbZLCUB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 15:01:29 -0500
Date: Thu, 3 Dec 2009 11:58:58 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Paris <eparis@redhat.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       uclinux-dist-devel@blackfin.uclinux.org, dhowells@redhat.com,
       gyang@blackfin.uclinux.org, john.johansen@canonical.com,
       Mike Frysinger <vapier.adi@gmail.com>, stable@kernel.org
Subject: Re: [PATCH] security: do not check mmap_min_addr on nommu systems
Message-Id: <20091203115858.d91b64dc.akpm@linux-foundation.org>
In-Reply-To: <20091203194300.8491.22110.stgit@paris.rdu.redhat.com>
References: <20091203194300.8491.22110.stgit@paris.rdu.redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 03 Dec 2009 14:43:01 -0500
Eric Paris <eparis@redhat.com> wrote:

> nommu systems can do anything with memory they please and so they already
> win.  mmap_min_addr is the least of their worries.  Currently the
> mmap_min_addr implementation is problamatic on such systems.  This patch
> changes the addr_only argument to be a flags which can take the arguments
> for addr_only or not_addr.  LSMs then need to properly implement these two
> flags.

This replaces David's
nommu-ignore-the-address-parameter-in-the-file_mmap-security-check.patch,
which missed 2.6.32.

What are our thoughts wrt backporting this fix in some form into
2.6.32.x and earlier?


