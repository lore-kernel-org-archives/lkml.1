Return-Path: <linux-kernel-owner+w=401wt.eu-S1764252AbXKNVBP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764252AbXKNVBP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 16:01:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754891AbXKNVBA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 16:01:00 -0500
Received: from xenotime.net ([66.160.160.81]:54531 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752063AbXKNVA7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 16:00:59 -0500
Date: Wed, 14 Nov 2007 13:00:52 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: Roland Dreier <rdreier@cisco.com>
Cc: Julia Lawall <julia@diku.dk>, rolandd@cisco.com, mshefty@ichips.intel.com,
       halr@voltaire.com, openib-general@openib.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 3/4] drivers/infiniband: Drop redundant includes of
 moduleparam.h
Message-Id: <20071114130052.8118c397.rdunlap@xenotime.net>
In-Reply-To: <adalk90zgwz.fsf@cisco.com>
References: <Pine.LNX.4.64.0711132234110.18337@ask.diku.dk>
	<adalk90zgwz.fsf@cisco.com>
Organization: YPO4
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Nov 2007 12:54:52 -0800 Roland Dreier wrote:

>  > Drop #include <linux/moduleparam.h> in files that also include #include
>  > <linux/module.h>.  module.h includes moduleparam.h already.
> 
> Do we want to make this sort of source code change?  I thought that
> the consensus about the kernel was that we wanted to avoid relying of
> implicit includes of <Y.h> by <X.h> -- in this case a better change
> would actually seem to be to explicitly include moduleparam.h in files
> using module parameters and then remove the include from module.h.

That's correct AFAIK (what Roland said).

---
~Randy
