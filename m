Return-Path: <linux-kernel-owner+w=401wt.eu-S1754029AbXJYEMN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029AbXJYEMN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 00:12:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761537AbXJYELz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 00:11:55 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39926 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761491AbXJYELy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 00:11:54 -0400
Date: Wed, 24 Oct 2007 21:11:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: matthias.kaehlcke@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch 0/3] MBCS: Convert semaphores to the mutex API
Message-Id: <20071024211149.2520a4ea.akpm@linux-foundation.org>
In-Reply-To: <20071024170858.GH9824@traven>
References: <20071024170858.GH9824@traven>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Oct 2007 19:08:58 +0200 matthias.kaehlcke@gmail.com wrote:

> MBCS: Convert the semaphores algolock, dmareadlock and dmawritelock to the 
> mutex API

Thanks.  Has this actually been runtime-tested?

btw, your patches are in `patch -p2' form:

--- kernel.orig/linux-2.6/drivers/char/mbcs.c
+++ kernel/linux-2.6/drivers/char/mbcs.c

should have been in `patch -p1' form:

--- linux-2.6/drivers/char/mbcs.c
+++ linux-2.6/drivers/char/mbcs.c

I'd suggest that you grab and learn
http://savannah.nongnu.org/projects/quilt/ - it takes care of all these
things for you.

