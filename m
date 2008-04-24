Return-Path: <linux-kernel-owner+w=401wt.eu-S1756237AbYDXBk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237AbYDXBk2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 21:40:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752633AbYDXBkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 21:40:19 -0400
Received: from mga11.intel.com ([192.55.52.93]:21875 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752589AbYDXBkR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 21:40:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,701,1199692800"; 
   d="scan'208";a="556384140"
Date: Thu, 24 Apr 2008 09:33:31 +0800
From: Alek Du <alek.du@intel.com>
To: "Jean Delvare" <khali@linux-fr.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] i2c: Add Intel SCH I2C SMBus support
Message-ID: <20080424093331.14141749@dxy.sh.intel.com>
In-Reply-To: <20080423143212.36dba2ea@hyperion.delvare>
References: <20080422100420.3ee5f150@dxy.sh.intel.com>
	<20080423143212.36dba2ea@hyperion.delvare>
Organization: Intel
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Apr 2008 01:40:14.0767 (UTC) FILETIME=[24A2DBF0:01C8A5AC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jean,

The SCH chipsets were launched during the recent Intel spring IDF. They
are chipsets for Intel Atom processor. The chipset and processor
are for LPIA embedded systems such as MID, automotive, classmate PC,
etc.

I will also post the patch to i2c@lm-sensors.org

Thanks,
Alek

On Wed, 23 Apr 2008 20:32:12 +0800
"Jean Delvare" <khali@linux-fr.org> wrote:

> Re: [PATCH 2/3] i2c: Add Intel SCH I2C SMBus support
> 
> Hi Alek,
> 
> On Tue, 22 Apr 2008 10:04:20 +0800, alek du wrote:
> > This patch adds Intel SCH chipsets (US15W, US15L, UL11L) i2c bus
> > support.
> 
> What kind of machines are these?
> 
> >
> > Signed-off-by: Alek Du <alek.du@intel.com>
> > ---
> >  drivers/i2c/busses/Kconfig   |    7 +
> >  drivers/i2c/busses/Makefile  |    1 +
> >  drivers/i2c/busses/i2c-sch.c |  419
> > ++++++++++++++++++++++++++++++++++++++++++ 3 files changed, 427
> > insertions(+), 0 deletions(-) create mode 100644
> > drivers/i2c/busses/i2c-sch.c (...)
> 
> MAINTAINERS says:
> 
> I2C SUBSYSTEM
> (...)
> L:      i2c@lm-sensors.org
> 
> So it would be great if you could send your patch there rather than on
> LKML.
> 
> Thanks,
> --
> Jean Delvare
