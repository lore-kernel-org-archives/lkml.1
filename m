Return-Path: <linux-kernel-owner+w=401wt.eu-S1754759AbYHGQ1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759AbYHGQ1T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 12:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752436AbYHGQ1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 12:27:08 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:54197 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751826AbYHGQ1H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 12:27:07 -0400
Date: Thu, 7 Aug 2008 19:25:32 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Joerg Roedel <joro@8bytes.org>
Cc: Tony Luck <tony.luck@intel.com>, linux-ia64@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [IA64] defconfig build failure in current linus.git
Message-ID: <20080807162532.GB9692@cs181140183.pp.htv.fi>
References: <20080807101015.GB4342@8bytes.org> <20080807143303.GA9692@cs181140183.pp.htv.fi> <20080807161222.GT31439@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080807161222.GT31439@8bytes.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 07, 2008 at 06:12:22PM +0200, Joerg Roedel wrote:
> On Thu, Aug 07, 2008 at 05:33:04PM +0300, Adrian Bunk wrote:
> > On Thu, Aug 07, 2008 at 12:10:15PM +0200, Joerg Roedel wrote:
> > > Hi,
> > > 
> > > I just tried to build the current linus.git kernel for IA64 and got the
> > > following build errors:
> > > 
> > >   CC      drivers/acpi/utils.o
> > > In file included from /data2/repos/tip/linux.trees.git/include/acpi/acpi.h:54,
> > >                  from /data2/repos/tip/linux.trees.git/include/acpi/acpi_bus.h:31,
> > >                  from /data2/repos/tip/linux.trees.git/drivers/acpi/utils.c:30:
> > > /data2/repos/tip/linux.trees.git/include/acpi/platform/acenv.h:175:1: warning: "COMPILER_DEPENDENT_INT64" redefined
> > >...
> > 
> > If you get this error your compiler does not define __linux__ .
> > 
> > What compiler are you using?
> 
> Its a self-build gcc-4.3.1 cross compiler on amd64. In the meantime it
> worked with a gcc 3.4.5. I will check if my self-build compiler is
> messed up.

My self-build gcc 4.3.1 configured for an ia64-linux target builds all 
ia64 defconfigs just fine.

> Joerg

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

