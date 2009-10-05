Return-Path: <linux-kernel-owner+w=401wt.eu-S1753760AbZJEUcH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753760AbZJEUcH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 16:32:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752897AbZJEUcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 16:32:06 -0400
Received: from mail.perches.com ([173.55.12.10]:1875 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752441AbZJEUcF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 16:32:05 -0400
Subject: Re: [PATCH 15/21] kernel/power/: use pr_<level> and add pr_fmt(fmt)
From: Joe Perches <joe@perches.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
       Len Brown <len.brown@intel.com>, linux-pm@lists.linux-foundation.org
In-Reply-To: <200910052143.37985.rjw@sisk.pl>
References: <cover.1254701151.git.joe@perches.com>
	 <17906d40d7b002380e893d49639ba3f1e7bdb3a0.1254701151.git.joe@perches.com>
	 <200910052143.37985.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 05 Oct 2009 13:31:27 -0700
Message-Id: <1254774687.1799.566.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-05 at 21:43 +0200, Rafael J. Wysocki wrote:
> On Monday 05 October 2009, Joe Perches wrote:
> > Added #define pr_fmt(fmt) "PM: " fmt
> > Converted printk(KERN_<level> to pr_<level>(
> > Removed "PM: " prefix
> > Added pr_fmt() to __initdata strings
> 
> Well, can you please tell me what actually is wrong with the current code?

Not much.  There were a couple of trivial corrections,
but perhaps the changes add a bit more flexibility and
regularity.

Effective trivial changes:

o Added KERN_CONT (pr_cont) to a couple of messages
o Added "PM: " (pr_info) to an #ifdef'd message
o Added "PM: " (pr_info) to a printk "Syncing filesystems ..."
  in power/user.c

cheers, Joe

