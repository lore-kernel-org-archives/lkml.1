Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755065Ab0BSRBM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 12:01:12 -0500
Received: from kroah.org ([198.145.64.141]:57707 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754916Ab0BSRAz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 12:00:55 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Feb 19 08:32:47 2010
Message-Id: <20100219163247.447437229@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 19 Feb 2010 08:29:54 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Kashyap Desai <kashyap.desai@lsi.com>,
       James Bottomley <James.Bottomley@suse.de>
Subject: [61/93] SCSI: mptfusion : mptscsih_abort return value should be SUCCESS instead of value 0.
In-Reply-To: <20100219165717.GA15002@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Kashyap, Desai <kashyap.desai@lsi.com>

commit 9858ae38011d699d4c2fa7f3493a47accf43a0f5 upstream.

retval should be SUCCESS/FAILED which is defined at scsi.h
retval = 0 is directing wrong return value. It must be retval = SUCCESS.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/message/fusion/mptscsih.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -1720,7 +1720,7 @@ mptscsih_abort(struct scsi_cmnd * SCpnt)
 		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "task abort: "
 		   "Command not in the active list! (sc=%p)\n", ioc->name,
 		   SCpnt));
-		retval = 0;
+		retval = SUCCESS;
 		goto out;
 	}
 


