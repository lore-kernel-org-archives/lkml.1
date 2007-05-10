Return-Path: <linux-kernel-owner+w=401wt.eu-S1756843AbXEJFKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756843AbXEJFKU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 01:10:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755157AbXEJFKH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 01:10:07 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:35926 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755058AbXEJFKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 01:10:03 -0400
Date: Wed, 9 May 2007 22:09:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: jeff@garzik.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, htejun@gmail.com,
       "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: Re: [patch 1/7] libata: check for AN support
Message-Id: <20070509220952.5fa34822.akpm@linux-foundation.org>
In-Reply-To: <20070509163809.7b0b3fde.kristen.c.accardi@intel.com>
References: <20070510072247.063476979@intel.com>
	<20070509163809.7b0b3fde.kristen.c.accardi@intel.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 May 2007 16:38:09 -0700 Kristen Carlson Accardi <kristen.c.accardi@intel.com> wrote:

>  /**
> + *	ata_dev_set_AN - Issue SET FEATURES - SATA FEATURES
> + *                       with sector count set to indicate
> + *                       Asynchronous Notification feature

I think kenreldoc requires that all this be on a single line?

> + *	@dev: Device to which command will be sent
> + *
> + *	Issue SET FEATURES - SATA FEATURES command to device @dev
> + *	on port @ap.
> + *
> + *	LOCKING:
> + *	PCI/etc. bus probe sem.
> + *
> + *	RETURNS:
> + *	0 on success, AC_ERR_* mask otherwise.
> + */

ooh, locking and return value documentation.  Often missed, and nice.
