Return-Path: <linux-kernel-owner+w=401wt.eu-S1751208AbZIUP45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751208AbZIUP45 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 11:56:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750952AbZIUP44
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 11:56:56 -0400
Received: from fifo99.com ([67.223.236.141]:36944 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750878AbZIUP4z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 11:56:55 -0400
Subject: RE: [PATCH 1/12] scsi: megaraid_sas - tape drive support fix
From: Daniel Walker <dwalker@fifo99.com>
To: "Yang, Bo" <Bo.Yang@lsi.com>
Cc: "James.Bottomley@HansenPartnership.com" 
	<James.Bottomley@HansenPartnership.com>,
       "James.Bottomley@suse.de" <James.Bottomley@suse.de>,
       "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
       "akpm@osdl.org" <akpm@osdl.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C35C5124EB@cosmail02.lsi.com>
References: <4B6A08C587958942AA3002690DD4F8C35C5123FA@cosmail02.lsi.com>
	 <1253504435.9654.221.camel@desktop>
	 <4B6A08C587958942AA3002690DD4F8C35C5124EB@cosmail02.lsi.com>
Content-Type: text/plain
Date: Mon, 21 Sep 2009 08:57:02 -0700
Message-Id: <1253548622.9654.233.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-09-21 at 09:22 -0600, Yang, Bo wrote:
> Daniel,
> 
> Thanks for viewing the patches.  I did run the checkpatch.pl first before I submit the patches.  Is there possible you can tell me the errors in the specific patch, I need to find out if it is my e-mail setting problems or something else.

There are problems in all your patches.. 

>From patch 1 (not all the errors),

ERROR: patch seems to be corrupt (line wrapped?)
#73: FILE: drivers/scsi/megaraid/megaraid_sas.c:686:
 memcpy(pthru->cdb, scp->cmnd, scp->cmd_len);

ERROR: Invalid UTF-8, patch and commit message should be encoded in
UTF-8
#76: FILE: drivers/scsi/megaraid/megaraid_sas.c:688:
+ * If the command is for the tape device, set the
 ^

ERROR: Invalid UTF-8, patch and commit message should be encoded in
UTF-8
#77: FILE: drivers/scsi/megaraid/megaraid_sas.c:689:
+ * pthru timeout to the os layer timeout value.

>From patch 2,

WARNING: suspect code indent for conditional statements (7, 15)
#107: FILE: drivers/scsi/megaraid/megaraid_sas.c:1306:
+       if ((!cmd->abort_aen) && (instance->unload == 0)) {
+               spin_lock_irqsave(&poll_aen_lock, flags);

ERROR: code indent should use tabs where possible
#108: FILE: drivers/scsi/megaraid/megaraid_sas.c:1307:
+               spin_lock_irqsave(&poll_aen_lock, flags);$

ERROR: code indent should use tabs where possible
#109: FILE: drivers/scsi/megaraid/megaraid_sas.c:1308:
+               megasas_poll_wait_aen = 1;$


Actually, now that I look closer, other than the errors from patch 1 the
rest of the patches have warnings similar to patch 2.. Did you do some
type of copy&paste to put the patches into each email? Often times that
will remove all the tabs which could cause the errors above.

Daniel


