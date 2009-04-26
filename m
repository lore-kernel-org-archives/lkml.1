Return-Path: <linux-kernel-owner+w=401wt.eu-S1758871AbZDZMnh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758871AbZDZMnh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 08:43:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757017AbZDZMf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 08:35:26 -0400
Received: from ozlabs.org ([203.10.76.45]:46086 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757000AbZDZMfY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 08:35:24 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Benny Halevy <bhalevy@panasas.com>
Subject: Re: [PATCH] lib: find_last_bit.o needed by a module only, move it from lib to obj
Date: Sun, 26 Apr 2009 22:05:19 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Fred Isaman <iisaman@citi.umich.edu>,
       Trond Myklebust <Trond.Myklebust@netapp.com>
References: <1240494032-9674-1-git-send-email-bhalevy@panasas.com>
In-Reply-To: <1240494032-9674-1-git-send-email-bhalevy@panasas.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904262205.20608.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Apr 2009 11:10:32 pm Benny Halevy wrote:
> From: Fred Isaman <iisaman@citi.umich.edu>
> 
> Currently, although find_last_bit is EXPORTed, it is statically linked with
> the lernel and is referenced only under CONFIG_SMP.

Acked-by: Rusty Russell <rusty@rustcorp.com.au>

We know that any EXPORT_SYMBOL in lib-y is dubious, at least, but we're
lazy (ISTR it would gut lib-y to exclude them all).

Thanks,
Rusty.
