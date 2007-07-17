Return-Path: <linux-kernel-owner+w=401wt.eu-S1765340AbXGQAyd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765340AbXGQAyd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 20:54:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755892AbXGQAyZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 20:54:25 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42038 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755426AbXGQAyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 20:54:24 -0400
Date: Mon, 16 Jul 2007 17:53:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: block/bsg.c
Message-Id: <20070716175347.bea345dd.akpm@linux-foundation.org>
In-Reply-To: <469C11B1.8000302@garzik.org>
References: <20070716165706.348f6bbf.akpm@linux-foundation.org>
	<469C11B1.8000302@garzik.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jul 2007 20:47:45 -0400 Jeff Garzik <jeff@garzik.org> wrote:

> Andrew Morton wrote:
> > The modern way of shutting up gcc is uninitialized_var().
> 
> 
> Should I convert my misc-2.6.git#gccbug repository over to this, and 
> push upstream?

Opinions differ (a bit) but personally I think the benefit of fixing the
warnings outweighs the risk that these suppressions will later hide a real
bug.

Certainly, using uninitialized_var() is better than open-coding "= 0" all
over the place.

Purists can add a config variable to centrally disable uninitialized_var()
if they want to check on the warnings.

> #gccbug branch is a set of places where I have verified that the 
> variable is indeed initialized, even though gcc complains it may not be.
> 

Do it!
