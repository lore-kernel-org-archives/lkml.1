Return-Path: <linux-kernel-owner+w=401wt.eu-S1758075AbXEJFOx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758075AbXEJFOx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 01:14:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755006AbXEJFOn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 01:14:43 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:52545 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754917AbXEJFOm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 01:14:42 -0400
Message-ID: <4642AA3E.4090308@garzik.org>
Date: Thu, 10 May 2007 01:14:38 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, htejun@gmail.com,
       "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: Re: [patch 1/7] libata: check for AN support
References: <20070510072247.063476979@intel.com>	<20070509163809.7b0b3fde.kristen.c.accardi@intel.com> <20070509220952.5fa34822.akpm@linux-foundation.org>
In-Reply-To: <20070509220952.5fa34822.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>> + *	@dev: Device to which command will be sent
>> + *
>> + *	Issue SET FEATURES - SATA FEATURES command to device @dev
>> + *	on port @ap.
>> + *
>> + *	LOCKING:
>> + *	PCI/etc. bus probe sem.
>> + *
>> + *	RETURNS:
>> + *	0 on success, AC_ERR_* mask otherwise.
>> + */
> 
> ooh, locking and return value documentation.  Often missed, and nice.


We set high standards in the libata world ;-)

	Jeff


