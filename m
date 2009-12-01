Return-Path: <linux-kernel-owner+w=401wt.eu-S1754195AbZLAQP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195AbZLAQP0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 11:15:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754153AbZLAQPZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 11:15:25 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47934 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754067AbZLAQPZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 11:15:25 -0500
Date: Tue, 1 Dec 2009 17:14:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, akpm@linux-foundation.org, steved@redhat.com,
       jens.axboe@oracle.com, linux-cachefs@redhat.com, nfsv4@linux-nfs.org,
       linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com,
       linux-kernel@vger.kernel.org, linux-cifs-client@lists.samba.org
Subject: Re: [PATCH] SLOW_WORK: Move slow_work's proc file to debugfs
Message-ID: <20091201161455.GB24897@elte.hu>
References: <6941.1259681771@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6941.1259681771@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Howells <dhowells@redhat.com> wrote:

> Move slow_work's debugging proc file to debugfs.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
> 
>  Documentation/slow-work.txt |    4 -
>  include/linux/slow-work.h   |    8 +-
>  init/Kconfig                |    8 +-
>  kernel/Makefile             |    2 
>  kernel/slow-work-debugfs.c  |  227 +++++++++++++++++++++++++++++++++++++++++++
>  kernel/slow-work-proc.c     |  227 -------------------------------------------
>  kernel/slow-work.c          |   18 ++-
>  kernel/slow-work.h          |    6 +
>  8 files changed, 253 insertions(+), 247 deletions(-)
>  create mode 100644 kernel/slow-work-debugfs.c
>  delete mode 100644 kernel/slow-work-proc.c

Nice - thanks for doing this so quickly! It might sound like nitpicking 
but /proc ABIs tend to be a lot harder to get rid of than debugfs 
interfaces.

	Ingo
