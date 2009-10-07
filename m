Return-Path: <linux-kernel-owner+w=401wt.eu-S1759125AbZJGNzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759125AbZJGNzk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 09:55:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758794AbZJGNzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 09:55:40 -0400
Received: from mail.perches.com ([173.55.12.10]:1984 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758769AbZJGNzj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 09:55:39 -0400
Subject: Re: [PATCH 1/7] printk: clean up return value
From: Joe Perches <joe@perches.com>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: mingo@redhat.com, x86@kernel.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
In-Reply-To: <1254904787-11323-2-git-send-email-alan-jenkins@tuffmail.co.uk>
References: <1254904787-11323-1-git-send-email-alan-jenkins@tuffmail.co.uk>
	 <1254904787-11323-2-git-send-email-alan-jenkins@tuffmail.co.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 07 Oct 2009 06:55:02 -0700
Message-Id: <1254923702.2134.358.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-07 at 09:39 +0100, Alan Jenkins wrote:
> Commit 5fd29d6 "printk: clean up handling of log-levels and newlines"
> causes printk() to return the wrong number of characters.

Maybe it'd be better to return void?

These may be the only uses of the value returned,
and both files are trivial to modify.

kernel/lockdep.c:	len += printk("%*s   %s", depth, "", usage_str[bit]);
kernel/lockdep.c:	len += printk(" at:\n");
drivers/char/mem.c:	ret = printk("%s", tmp);


