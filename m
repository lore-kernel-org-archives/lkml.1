Return-Path: <linux-kernel-owner+w=401wt.eu-S932529AbZHNPRg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932529AbZHNPRg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 11:17:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932508AbZHNPRf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 11:17:35 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:36932 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932454AbZHNPRf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 11:17:35 -0400
Subject: Re: [patch 08/11] jfs: cleanup unload_nls() calls
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>
In-Reply-To: <20090814123548.555482868@linutronix.de>
References: <20090814122657.114987508@linutronix.de>
	 <20090814123548.555482868@linutronix.de>
Content-Type: text/plain
Date: Fri, 14 Aug 2009 10:17:33 -0500
Message-Id: <1250263053.32033.3.camel@norville.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-08-14 at 12:43 +0000, Thomas Gleixner wrote:

> unload_nls() can be called with a NULL pointer now. Remove the pointer
> check and the NULLification of the pointer as the data structure which
> contains the pointer is kfree'd right away.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>

> ---
>  fs/jfs/super.c |    9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)

-- 
David Kleikamp
IBM Linux Technology Center

