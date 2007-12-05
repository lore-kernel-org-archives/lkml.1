Return-Path: <linux-kernel-owner+w=401wt.eu-S1754211AbXLEPoy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754211AbXLEPoy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 10:44:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752127AbXLEPor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 10:44:47 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:36998 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017AbXLEPoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 10:44:46 -0500
Date: Wed, 5 Dec 2007 07:47:21 -0800
From: Greg KH <greg@kroah.com>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       rsa@us.ibm.com, apw@shadowen.org, balbir@in.ibm.com
Subject: Re: 2.6.24-rc4-mm1 kobject changes broken with hvcs driver on
	powerpc
Message-ID: <20071205154721.GC23940@kroah.com>
References: <20071204211701.994dfce6.akpm@linux-foundation.org> <20071205141202.GB13189@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20071205141202.GB13189@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 05, 2007 at 07:42:02PM +0530, Kamalesh Babulal wrote:
> Hi Andrew,
> 
> The 2.6.24-rc4-mm1 kernel build fails with build failure,
> 
>   CC      drivers/char/hvcs.o
> drivers/char/hvcs.c: In function ‘hvcs_open’:
> drivers/char/hvcs.c:1180: error: wrong type argument to unary exclamation mark
> make[2]: *** [drivers/char/hvcs.o] Error 1
> make[1]: *** [drivers/char] Error 2
> make: *** [drivers] Error 2

Oops, sorry about that, my fault.  I'll merge your fix in with my
original patch, thanks for it.

greg k-h
