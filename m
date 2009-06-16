Return-Path: <linux-kernel-owner+w=401wt.eu-S1759499AbZFPRKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759499AbZFPRKU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 13:10:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754847AbZFPRKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 13:10:08 -0400
Received: from mga11.intel.com ([192.55.52.93]:42602 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754240AbZFPRKH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 13:10:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,230,1243839600"; 
   d="scan'208";a="699910128"
Date: Tue, 16 Jun 2009 10:10:09 -0700
From: Jesse Barnes <jesse.barnes@intel.com>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH V5: 3/3] pci: Provide Multiple Error Received support on
 AER
Message-ID: <20090616101009.521774ab@jbarnes-g45>
In-Reply-To: <1245130516.2560.394.camel@ymzhang>
References: <1245130516.2560.394.camel@ymzhang>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Jun 2009 13:35:16 +0800
"Zhang, Yanmin" <yanmin_zhang@linux.intel.com> wrote:

>     When a root port receive the same errors more than once before
> kernel process them, the Multiple Error Messages Received flags are
> set by hardware. Because root port could only save one kind of
> correctable error source id and another uncorrectable error source id
> at the same time, so the second message sender id is lost if the 2
> messages are sent from 2 different devices. Below patch searches all
> devices under the root port when multiple messages are received.
>     
>     Signed-off-by: Zhang Yanmin <yanmin_zhang@linux.intel.com>

Thanks for rebasing Yanmin; I applied this to my linux-next branch with
Andrew's reviewed-bys.

-- 
Jesse Barnes, Intel Open Source Technology Center
