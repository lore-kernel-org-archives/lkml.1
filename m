Return-Path: <linux-kernel-owner+w=401wt.eu-S1759181AbZELABX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759181AbZELABX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 20:01:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754456AbZELABO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 20:01:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:12725 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754139AbZELABN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 20:01:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,178,1241420400"; 
   d="scan'208";a="514578747"
Date: Mon, 11 May 2009 17:00:50 -0700
From: Jesse Barnes <jesse.barnes@intel.com>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH] Fix pci-e port driver slot_reset bad default return
 value
Message-ID: <20090511170050.69aa3ac0@jbarnes-g45>
In-Reply-To: <1241074109.2567.901.camel@ymzhang>
References: <1241074109.2567.901.camel@ymzhang>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Apr 2009 14:48:29 +0800
"Zhang, Yanmin" <yanmin_zhang@linux.intel.com> wrote:

> When an upstream port reports an AER error to root port, kernel
> starts error recovery procedures. The default return value of
> function pcie_portdrv_slot_reset is PCI_ERS_RESULT_NONE. If all
> port service drivers of the downstream port under the upstream
> port have no slot_reset method in pci_error_handlers, aer recovery
> would stop without resume. Below patch against 2.6.30-rc3 fixes it.
> 
> ﻿Signed-off-by: ﻿Zhang Yanmin <yanmin.zhang@linux.intel.com>

This one is in my for-linus branch now.  Thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
