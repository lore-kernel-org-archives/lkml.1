Return-Path: <linux-kernel-owner+w=401wt.eu-S1756283AbXEJPPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756283AbXEJPPm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 11:15:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755553AbXEJPPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 11:15:09 -0400
Received: from xenotime.net ([66.160.160.81]:46909 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755086AbXEJPPE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 11:15:04 -0400
Date: Thu, 10 May 2007 08:19:59 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>, jeff@garzik.org,
       linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, htejun@gmail.com,
       "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: Re: [patch 1/7] libata: check for AN support
Message-Id: <20070510081959.ba599dd0.rdunlap@xenotime.net>
In-Reply-To: <20070509220952.5fa34822.akpm@linux-foundation.org>
References: <20070510072247.063476979@intel.com>
	<20070509163809.7b0b3fde.kristen.c.accardi@intel.com>
	<20070509220952.5fa34822.akpm@linux-foundation.org>
Organization: YPO4
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 May 2007 22:09:52 -0700 Andrew Morton wrote:

> On Wed, 9 May 2007 16:38:09 -0700 Kristen Carlson Accardi <kristen.c.accardi@intel.com> wrote:
> 
> >  /**
> > + *	ata_dev_set_AN - Issue SET FEATURES - SATA FEATURES
> > + *                       with sector count set to indicate
> > + *                       Asynchronous Notification feature
> 
> I think kenreldoc requires that all this be on a single line?

Correct.

> > + *	@dev: Device to which command will be sent
> > + *
> > + *	Issue SET FEATURES - SATA FEATURES command to device @dev
> > + *	on port @ap.
> > + *
> > + *	LOCKING:
> > + *	PCI/etc. bus probe sem.
> > + *
> > + *	RETURNS:
> > + *	0 on success, AC_ERR_* mask otherwise.
> > + */
> 
> ooh, locking and return value documentation.  Often missed, and nice.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
