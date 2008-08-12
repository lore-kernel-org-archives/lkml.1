Return-Path: <linux-kernel-owner+w=401wt.eu-S1751163AbYHLFjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751163AbYHLFjc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 01:39:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751751AbYHLFjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 01:39:12 -0400
Received: from mga03.intel.com ([143.182.124.21]:23382 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751572AbYHLFjK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 01:39:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,193,1217833200"; 
   d="scan'208";a="32656446"
Subject: Re: [ipw3945-devel] [PATCH 1/1] iwlwifi: fix printk newlines
From: Zhu Yi <yi.zhu@intel.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Jiri Slaby <jirislaby@gmail.com>, ipw3945-devel@lists.sourceforge.net,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <1218513565.25524.31.camel@californication>
References: <1218491381-1313-1-git-send-email-jirislaby@gmail.com>
	 <1218502555.25524.22.camel@californication>
	 <1218504137.3107.201.camel@debian.sh.intel.com>
	 <1218513565.25524.31.camel@californication>
Content-Type: text/plain
Organization: Intel Corp.
Date: Tue, 12 Aug 2008 13:38:16 +0800
Message-Id: <1218519496.3107.235.camel@debian.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-08-12 at 05:59 +0200, Marcel Holtmann wrote:
> > We should give the users more control to the style I think.
> 
> what kind of control do you expect? If you need two lines of debug or
> error output, call IWL_ERROR twice. This will also result in the
> KERN_ERR is set and not forgotten since that has to follow the
> newline.

I thought sometimes we might not need a new line between two IWL_ERRORs.
But your KERN_ERR garbaging the output in this case is correct. I think
when we wrote the macro, we just follow the style of dev_info() ...
dev_emerg() macros. Do you know why there is not a new line for them by
default?

Thanks,
-yi

