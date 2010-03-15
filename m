Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936189Ab0COMI0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 08:08:26 -0400
Received: from cantor.suse.de ([195.135.220.2]:44310 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936097Ab0COMIW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 08:08:22 -0400
Date: Mon, 15 Mar 2010 13:08:32 +0100
From: Jan Kara <jack@suse.cz>
To: Dan Carpenter <error27@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Hannes Eder <hannes@hanneseder.net>,
       Akinobu Mita <akinobu.mita@gmail.com>,
       Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [patch] udf: potential integer overflow
Message-ID: <20100315120832.GA4151@quack.suse.cz>
References: <20100315082113.GC18181@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100315082113.GC18181@bicker>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 15-03-10 11:21:13, Dan Carpenter wrote:
> bloc->logicalBlockNum is unsigned so it's never less than zero.
> 
> When I saw that, it made me worry that "bloc->logicalBlockNum + count"
> could overflow.  That's why I changed the check for less than zero
> to an overflow check.  (The test works because "count" is also 
> unsigned.)
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
  Thanks. Merged.

> ---
> GCC 4.1 apparently optimizes overflow checks like this away, but it should
> work for other versions of gcc.  I tested with GCC 4.3.
> http://www.fefe.de/intof.html
  It should only optimize them out for signed types (moreover kernel has
this optimization turned off so it's a non-issue for us anyway). 

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
