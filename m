Return-Path: <linux-kernel-owner+w=401wt.eu-S1767497AbXDFCTX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767497AbXDFCTX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 22:19:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767499AbXDFCTX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 22:19:23 -0400
Received: from animx.eu.org ([216.98.75.249]:52788 "EHLO animx.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767497AbXDFCTW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 22:19:22 -0400
Date: Thu, 5 Apr 2007 22:16:51 -0400
From: Wakko Warner <wakko@animx.eu.org>
To: linux-kernel@vger.kernel.org
Subject: AIC79xx: scsi0: device overrun (status a)
Message-ID: <20070406021651.GA25060@animx.eu.org>
Mail-Followup-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.6+20040907i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Can anyone tell me what this means:
Apr  5 22:11:56 vegeta kernel: [ 1265.267700] scsi0: device overrun (status a) on 0:1:0

Kernel is 2.6.20.

I setup a raid1 between 2 hard disks (on partition #2), as soon as it
started to sync the array, my log was flooded with the above entry.

The scsi adapter is an onboard controller on a supermicro x5da8.  The hard
disks are SEAGATE ST318404LW drives on channel 0 (no other devices on this
channel).

>From what I can tell, the speed of the sync is going fairly quickly. 
~29mb/sec

This is really strange to me, since I dd'd from the first disk to the second
with out any messages in the log (It was an older kernel, 2.6.17)

If there's any other information needed, ask.  I'm not sure what else is
needed.

-- 
 Lab tests show that use of micro$oft causes cancer in lab animals
 Got Gas???
