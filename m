Return-Path: <linux-kernel-owner+w=401wt.eu-S1755755Ab0ASK54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755755Ab0ASK54 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 05:57:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755060Ab0ASK5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 05:57:54 -0500
Received: from mga06.intel.com ([134.134.136.21]:45710 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752841Ab0ASK5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 05:57:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,302,1262592000"; 
   d="scan'208";a="485131939"
Date: Tue, 19 Jan 2010 11:59:27 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Cory Maccarrone <darkstar6262@gmail.com>
Subject: Re: linux-next: mfd tree build failure
Message-ID: <20100119105926.GA554@sortiz.org>
References: <20100119150653.1b9bbf67.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100119150653.1b9bbf67.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Tue, Jan 19, 2010 at 03:06:53PM +1100, Stephen Rothwell wrote:
> Hi Samuel,
> 
> Today's linux-next build (x86_64 allmodconfig) failed like this:
> 
> drivers/mfd/htc-i2cpld.c: In function 'htcpld_set_type':
> drivers/mfd/htc-i2cpld.c:106: error: 'irq_desc' undeclared (first use in this function)
> 
> Caused by commit b4714172cd2f1cd8694546169237c30c5b4fdf3b ("mfd: Add
> HTCPLD driver").
Thanks for the report. It should be all fixed now.

Cheers,
Samuel.


> I have used the mfd tree from next-20100118 for today.
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/



-- 
Intel Open Source Technology Centre
http://oss.intel.com/
