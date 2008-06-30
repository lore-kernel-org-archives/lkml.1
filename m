Return-Path: <linux-kernel-owner+w=401wt.eu-S1763327AbYF3SjA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763327AbYF3SjA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 14:39:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754182AbYF3Siw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 14:38:52 -0400
Received: from brick.kernel.dk ([87.55.233.238]:14981 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753467AbYF3Siv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 14:38:51 -0400
Date: Mon, 30 Jun 2008 20:38:48 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-next@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
       mingo <mingo@redhat.com>, tglx <tglx@linutronix.de>,
       hpa <hpa@zytor.com>, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH -next] fork and exit: need to include iocontext.h
Message-ID: <20080630183848.GR20826@kernel.dk>
References: <20080630105458.7c95e195.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080630105458.7c95e195.randy.dunlap@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30 2008, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix fork and exit build errors: they need to include iocontext.h:
> 
> linux-next-20080630/kernel/fork.c: In function 'copy_process':
> linux-next-20080630/kernel/fork.c:1237: error: implicit declaration of function 'put_io_context'
> linux-next-20080630/kernel/exit.c: In function 'do_exit':
> linux-next-20080630/kernel/exit.c:992: error: implicit declaration of function 'exit_io_context'

Thanks Randy, I've updated the patch.

-- 
Jens Axboe

