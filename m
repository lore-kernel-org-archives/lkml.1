Return-Path: <linux-kernel-owner+w=401wt.eu-S933156AbXKOVbw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933156AbXKOVbw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 16:31:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755113AbXKOVbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 16:31:43 -0500
Received: from ra.tuxdriver.com ([70.61.120.52]:4269 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754375AbXKOVbm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 16:31:42 -0500
Date: Thu, 15 Nov 2007 16:31:18 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Zhu Yi <yi.zhu@intel.com>
Cc: Miguel =?iso-8859-1?Q?Bot=F3n?= <mboton.lkml@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-wireless@vger.kernel.org
Subject: Re: [PATCH] iwlwifi: Remove unnecessary code in iwl3945 and
	iwl4965 drivers
Message-ID: <20071115213118.GE12902@tuxdriver.com>
References: <200711102049.32921.mboton.lkml@gmail.com> <1194829690.31574.70.camel@debian.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1194829690.31574.70.camel@debian.sh.intel.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 12, 2007 at 09:08:10AM +0800, Zhu Yi wrote:
> 
> On Sat, 2007-11-10 at 20:49 +0100, Miguel Botón wrote:
> > Remove unnecesary code in iwl3945 and iwl4965 drivers.
> > 
> > "final_mode" variable is already initialized with the value of the
> > "mode" variable.
> > 
> > Signed-off-by: Miguel Boton <mboton@gmail.com>
> 
> ACK. Or you can do "u32 uninitialized_var(final_mode);". Both are OK
> with me.

I think I like this alternative better...

-- 
John W. Linville
linville@tuxdriver.com
