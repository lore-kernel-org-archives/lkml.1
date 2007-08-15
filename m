Return-Path: <linux-kernel-owner+w=401wt.eu-S1760693AbXHOOCM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760693AbXHOOCM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 10:02:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754566AbXHOOBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 10:01:53 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:45859 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751363AbXHOOBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 10:01:51 -0400
Subject: Re: [patch 2/4] scsi: expose AN support to user space
From: James Bottomley <James.Bottomley@SteelEye.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <46C2B59A.6070200@garzik.org>
References: <20070808190613.616085010@localhost.localdomain>
	 <20070808120822.9cf187bb.kristen.c.accardi@intel.com>
	 <46C2B59A.6070200@garzik.org>
Content-Type: text/plain
Date: Wed, 15 Aug 2007 09:01:49 -0500
Message-Id: <1187186509.3327.7.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-08-15 at 04:13 -0400, Jeff Garzik wrote:
> Kristen Carlson Accardi wrote:
> > If a scsi_device supports async notification for media change, then
> > let user space know this capability exists by creating a new sysfs
> > entry "media_change_notify", which will be 1 if it is supported, and
> > 0 if not supported.  Create a routine which allows scsi devices to
> > send a uevent when media change events occur.
> > 
> > Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
> 
> if James is happy with this patch, I'm happy with patch #2 and #3

Actually, we just got a second potential consumer ... although I'll
reprod to have the reporter send it to the list.  It's a device that
needs notice of report luns data changing.  The proposed mechanism looks
a bit narrow now (too tied to media change).  I'll see if I can propose
a more generic update.

James


