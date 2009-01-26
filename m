Return-Path: <linux-kernel-owner+w=401wt.eu-S1755292AbZAZXji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292AbZAZXji (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 18:39:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752592AbZAZXja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 18:39:30 -0500
Received: from smtpauth05.prod.mesa1.secureserver.net ([64.202.165.99]:44595
	"HELO smtpauth05.prod.mesa1.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751702AbZAZXja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 18:39:30 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Jan 2009 18:39:30 EST
Message-ID: <497E4821.6000902@gridplexus.com>
Date: Mon, 26 Jan 2009 18:32:49 -0500
From: support <support@gridplexus.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20081001)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: xen-2.6.18-92.1.22.el5.i686 with 2010s 
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using kernel xen-2.6.18-92.1.22.el5.i686 with 2010s results in kernel 
panic (not syncing).  The non-xen kernel is used in the initial 
kickstart.  After verifying grub, disk labels in rescue mode, etc, I am 
wondering if anyone has had success with the adaptec 2010s and xen?  The 
same hardware boots successfully with the smp 2.6.18-92.1.22. 

grep  I2O .config

# I2O device support
CONFIG_SCSI_DPT_I2O=y
# I2O device support
CONFIG_I2O=m
# CONFIG_I2O_LCT_NOTIFY_ON_CHANGES is not set
CONFIG_I2O_EXT_ADAPTEC=y
CONFIG_I2O_CONFIG=m
CONFIG_I2O_CONFIG_OLD_IOCTL=y
CONFIG_I2O_BUS=m
CONFIG_I2O_BLOCK=m
CONFIG_I2O_SCSI=m
CONFIG_I2O_PROC=m


Thanks in advance.
Robert
 
