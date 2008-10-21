Return-Path: <linux-kernel-owner+w=401wt.eu-S1754432AbYJUWpY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754432AbYJUWpY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 18:45:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751597AbYJUWpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 18:45:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50322 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751195AbYJUWpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 18:45:07 -0400
Date: Tue, 21 Oct 2008 15:44:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Miller <mike.miller@hp.com>
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp,
       adobriyan@gmail.com
Subject: Re: [PATCH 2/2] cciss:fix regression firmware not displayed in
 procfs (again and again)
Message-Id: <20081021154408.ed96c9b3.akpm@linux-foundation.org>
In-Reply-To: <20081021212322.GA6421@roadking.ldev.net>
References: <20081021212322.GA6421@roadking.ldev.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Oct 2008 16:23:22 -0500
Mike Miller <mike.miller@hp.com> wrote:

> Patch 2 of 2

What happened with "1 of 2"?

> Sorry for the delay. I've been out of the office and the network has been
> down since before lunch CDT. This regression was introduced by commit
> 6ae5ce8e8d4de666f31286808d2285aa6a50fa40.
> This patch fixes a regression where the controller firmware version is not
> displayed in procfs. The previous patch would be called anytime something
> changed. This will get called only once for each controller.
> 
> In this patch I again initialize *inq_buff to NULL per Tomo's comments. I
> also use a goto clean 4 instead of returning -ENOMEM if the kzalloc fails.
> 
> I hope this finally meets everyones expectations.
> 
> Please consider this for inclusion.
> 
> Signed-off-by: Mike Miller <mike.miller@hp.com>

So this fix is needed in 2.6.27.x, yes?
