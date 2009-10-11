Return-Path: <linux-kernel-owner+w=401wt.eu-S1755937AbZJKBuP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937AbZJKBuP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 21:50:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755782AbZJKBuO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 21:50:14 -0400
Received: from mail.perches.com ([173.55.12.10]:2065 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755645AbZJKBuN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 21:50:13 -0400
Subject: Re: [PATCH 15/21] kernel/power/: use pr_<level> and add pr_fmt(fmt)
From: Joe Perches <joe@perches.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
       Len Brown <len.brown@intel.com>, linux-pm@lists.linux-foundation.org
In-Reply-To: <200910102328.37108.rjw@sisk.pl>
References: <cover.1254701151.git.joe@perches.com>
	 <200910060037.57546.rjw@sisk.pl>
	 <1255060436.16347.36.camel@Joe-Laptop.home>
	 <200910102328.37108.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 10 Oct 2009 18:49:35 -0700
Message-Id: <1255225776.16347.352.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-10-10 at 23:28 +0200, Rafael J. Wysocki wrote:
> On Friday 09 October 2009, Joe Perches wrote:
> > Added #define pr_fmt(fmt) "PM: " fmt
> > Converted printk(KERN_<level> to pr_<level>(
> > Converted printks without KERN_ to pr_info or pr_cont
> > Removed hard coded "PM: " prefix from message strings
> > Added pr_fmt() to __initdata strings
> > Integrated multiple line strings
> > All logging messages are now output prefixed with "PM: "
> Does this patch depend on any other patch that haven't been merged yet?

No.  I think it's OK to merge.

The idea is to eventually have smaller objects without
prefixes, just a single stored prefix string that printk
would insert and a bit more consistent output.

cheers,  Joe


