Return-Path: <linux-kernel-owner+w=401wt.eu-S1760345AbXKPPBu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760345AbXKPPBu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 10:01:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752158AbXKPPBm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 10:01:42 -0500
Received: from ausc60pc101.us.dell.com ([143.166.85.206]:50206 "EHLO
	ausc60pc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746AbXKPPBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 10:01:42 -0500
DomainKey-Signature: s=smtpout; d=dell.com; c=nofws; q=dns; b=wlDWO66VV5CZTDe9oUxOS5AabwYD7dL7/ryi1O91jASrHoPIWTXVUe2TNBNUKL20d7zayT1DcU1pORZ0glXxL4CU9cBOm7gH5uxJWxObdEtJiZb4BY6Hdy0TtST83BoH;
X-IronPort-AV: E=Sophos;i="4.21,426,1188795600"; 
   d="scan'208";a="421995412"
Date: Fri, 16 Nov 2007 09:01:16 -0600
From: Matt Domsch <Matt_Domsch@dell.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
       Matt Tolentino <matthew.e.tolentino@intel.com>
Subject: Re: [PATCH 38/54] efivars: remove new_var and del_var files from sysfs
Message-ID: <20071116150116.GA8901@auslistsprd01.us.dell.com>
References: <20071102235758.GA9803@kroah.com> <1194047972-9850-38-git-send-email-gregkh@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1194047972-9850-38-git-send-email-gregkh@suse.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 02, 2007 at 04:59:16PM -0700, Greg Kroah-Hartman wrote:
> WTF?  Passing binary structures into a sysfs file, expecting it to be in
> the correct format/endianness?  That's just wrong on so many levels.
> 
> So, these files are deleted.  If you want to add them back, please do so
> in configfs, or in debugfs.  Or use text strings, which is what sysfs is
> only for.


I have tested gregkh's patches tree, which includes this patch, the
patch to put these back as binary blob interfaces, as well as other
cleanups, on an Itanium2 system.  The efibootmgr userspace application
continues to work as it did before this patch series, which I claim is
success.  For the patches that touch drivers/firmware/efivars.c I can
say:

Tested-by: Matt Domsch <Matt_Domsch@dell.com>

Thanks,
Matt

-- 
Matt Domsch
Linux Technology Strategist, Dell Office of the CTO
linux.dell.com & www.dell.com/linux
