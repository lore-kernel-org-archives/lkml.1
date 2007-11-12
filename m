Return-Path: <linux-kernel-owner+w=401wt.eu-S1756163AbXKLBPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163AbXKLBPZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 20:15:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751427AbXKLBPL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 20:15:11 -0500
Received: from mga01.intel.com ([192.55.52.88]:9062 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751288AbXKLBPJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 20:15:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,402,1188802800"; 
   d="scan'208";a="378754454"
Subject: Re: [PATCH] iwlwifi: Remove unnecessary code in iwl3945 and
	iwl4965 drivers
From: Zhu Yi <yi.zhu@intel.com>
To: Miguel =?ISO-8859-1?Q?Bot=F3n?= <mboton.lkml@gmail.com>,
       "John W.Linville" <linville@tuxdriver.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-wireless@vger.kernel.org
In-Reply-To: <200711102049.32921.mboton.lkml@gmail.com>
References: <200711102049.32921.mboton.lkml@gmail.com>
Content-Type: text/plain; charset=GB2312
Organization: Intel Corp.
Date: Mon, 12 Nov 2007 09:08:10 +0800
Message-Id: <1194829690.31574.70.camel@debian.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2007-11-10 at 20:49 +0100, Miguel Bot¨®n wrote:
> Remove unnecesary code in iwl3945 and iwl4965 drivers.
> 
> "final_mode" variable is already initialized with the value of the
> "mode" variable.
> 
> Signed-off-by: Miguel Boton <mboton@gmail.com>

ACK. Or you can do "u32 uninitialized_var(final_mode);". Both are OK
with me.

Thanks,
-yi
