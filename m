Return-Path: <linux-kernel-owner+w=401wt.eu-S1757472AbXKKWwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757472AbXKKWwe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 17:52:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756092AbXKKWw0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 17:52:26 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:52018 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756042AbXKKWwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 17:52:25 -0500
Date: Sun, 11 Nov 2007 23:52:24 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: axboe@kernel.dk, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Include header required for INT_MAX
Message-ID: <Pine.LNX.4.64.0711112349580.15517@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


>> Nack, we shoiuld never include userspace headers in kernel headers,
>> an even more never add !__KERNEL__ ifdefs.  Just make sure your
>> programs include limit.h before including linux/cdrom.h.
>
>I think header files should be complete, and should not use undefined
>macros, picking up every random definition that may be in effect when
>the header is included, don't you agree? 

No, because I be damn sure that some developers try compiling programs 
in non-linux environments (cygwin, solaris, andyourpersonaldistro, you 
name it) which do not have to adhere to <limits.h>. It might use 
<cosmiclimits.h> instead, or whatever.
Hence, such extra includes are a nogo.
