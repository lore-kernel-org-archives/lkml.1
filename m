Return-Path: <linux-kernel-owner+w=401wt.eu-S1756677AbXIEJls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756677AbXIEJls (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 05:41:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756131AbXIEJll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 05:41:41 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:52645 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755393AbXIEJlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 05:41:40 -0400
Date: Wed, 5 Sep 2007 11:41:39 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Rescanning SCSI/SATA bus
Message-ID: <Pine.LNX.4.64.0709051140130.5419@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


when trying to do a rescan on (1) sata_nv/2.6.18 (2) sym53c83xx/2.6.21, 
I get:

11:40 sun:~ # cd /sys/class/scsi_host/host0/
11:40 sun:../scsi_host/host0 # ls
can_queue    device     proc_name  sg_tablesize  subsystem  
unchecked_isa_dma
cmd_per_lun  host_busy  scan       state         uevent     unique_id
11:40 sun:../scsi_host/host0 # echo 1 >scan 
-bash: echo: write error: Invalid argument

What is the proper way to trigger a rescan, if it comes to be necessary?

thanks,
	Jan
-- 
