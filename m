Return-Path: <linux-kernel-owner+w=401wt.eu-S932306Ab0A1TEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932306Ab0A1TEW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 14:04:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932293Ab0A1TEV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 14:04:21 -0500
Received: from outbound-mail-313.bluehost.com ([67.222.54.6]:54786 "HELO
	outbound-mail-313.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756478Ab0A1TEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 14:04:20 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=i8Efn+wxlhlL/BcmLhQ8G1CSlXlPbzj955lJYgNPTlhpFk5kHM6+yevIJApnFLGxPjyZgxmTa9XyqcXla8Gn/H632BkIonSvKGkFtnYwtXJED/jr06a5ckFbS1NrOzLo;
Date: Thu, 28 Jan 2010 11:04:14 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
Subject: Re: linux-next: Tree for January 18 (pci + pm)
Message-ID: <20100128110414.10b73b9e@jbarnes-piketon>
In-Reply-To: <20100128083322.34679625.randy.dunlap@oracle.com>
References: <20100118195743.b45f119e.sfr@canb.auug.org.au>
	<20100118154424.d54c0e3e.randy.dunlap@oracle.com>
	<201001200004.07654.rjw@sisk.pl>
	<20100128083322.34679625.randy.dunlap@oracle.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Jan 2010 08:33:22 -0800
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> On Wed, 20 Jan 2010 00:04:07 +0100 Rafael J. Wysocki wrote:
> 
> > On Tuesday 19 January 2010, Randy Dunlap wrote:
> > > On Mon, 18 Jan 2010 19:57:43 +1100 Stephen Rothwell wrote:
> > > 
> > > > Hi all,
> > > > 
> > > > Changes since 20100114:
> > > 
> > > 
> > > drivers/pci/pci-driver.c: In function 'pci_pm_runtime_resume':
> > > drivers/pci/pci-driver.c:991: error: implicit declaration of
> > > function 'pci_pm_default_resume_early' drivers/pci/pci-driver.c:
> > > At top level: drivers/pci/pci-driver.c:1027: error:
> > > 'pci_pm_prepare' undeclared here (not in a function)
> > > drivers/pci/pci-driver.c:1028: error: 'pci_pm_complete'
> > > undeclared here (not in a function)
> > > drivers/pci/pci-driver.c:1029: error: 'pci_pm_suspend' undeclared
> > > here (not in a function) drivers/pci/pci-driver.c:1030: error:
> > > 'pci_pm_resume' undeclared here (not in a function)
> > > drivers/pci/pci-driver.c:1031: error: 'pci_pm_freeze' undeclared
> > > here (not in a function) drivers/pci/pci-driver.c:1032: error:
> > > 'pci_pm_thaw' undeclared here (not in a function)
> > > drivers/pci/pci-driver.c:1033: error: 'pci_pm_poweroff'
> > > undeclared here (not in a function)
> > > drivers/pci/pci-driver.c:1034: error: 'pci_pm_restore' undeclared
> > > here (not in a function) drivers/pci/pci-driver.c:1035: error:
> > > 'pci_pm_suspend_noirq' undeclared here (not in a function)
> > > drivers/pci/pci-driver.c:1036: error: 'pci_pm_resume_noirq'
> > > undeclared here (not in a function)
> > > drivers/pci/pci-driver.c:1037: error: 'pci_pm_freeze_noirq'
> > > undeclared here (not in a function)
> > > drivers/pci/pci-driver.c:1038: error: 'pci_pm_thaw_noirq'
> > > undeclared here (not in a function)
> > > drivers/pci/pci-driver.c:1039: error: 'pci_pm_poweroff_noirq'
> > > undeclared here (not in a function)
> > > drivers/pci/pci-driver.c:1040: error: 'pci_pm_restore_noirq'
> > > undeclared here (not in a function)
> > > 
> > > 
> > > partial config:
> > > 
> > > CONFIG_PM=y
> > > # CONFIG_PM_DEBUG is not set
> > > # CONFIG_SUSPEND is not set
> > > # CONFIG_HIBERNATION is not set
> > > CONFIG_PM_RUNTIME=y
> > > CONFIG_PM_OPS=y
> > > 
> > > 
> > > Full config is attached.
> > 
> > Ah, too many ifdefs.
> > 
> > Thanks, the patch below fixes that for me.
> > 
> > Rafael
> 
> Rafael, Jesse:
> 
> We still need this patch in linux-next (20100128).
> Thanks.
> 

Arg, I must have dropped this one too... will apply again and push.

-- 
Jesse Barnes, Intel Open Source Technology Center
