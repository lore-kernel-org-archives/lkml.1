Return-Path: <linux-kernel-owner+w=401wt.eu-S1756672AbYAQS4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756672AbYAQS4Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 13:56:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753010AbYAQS4C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 13:56:02 -0500
Received: from lixom.net ([66.141.50.11]:60153 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751645AbYAQS4A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 13:56:00 -0500
Date: Thu, 17 Jan 2008 13:06:39 -0600
From: Olof Johansson <olof@lixom.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, raisch@de.ibm.com,
       jgarzik@pobox.com
Subject: Re: 2.6.24-rc8-mm1 powerpc build errors
Message-ID: <20080117190639.GA9499@lixom.net>
References: <20080117023514.9df393cf.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080117023514.9df393cf.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

My powerpc build-all-defconfigs script found the following:

mpc837x_mds_defconfig. Brokage looks like it came from libata's
for_each_sg() patch.

drivers/ata/sata_fsl.c: In function 'sata_fsl_fill_sg':
drivers/ata/sata_fsl.c:337: error: redeclaration of 'si' with no linkage
drivers/ata/sata_fsl.c:326: error: previous declaration of 'si' was here

powerpc_allyesconfig:

drivers/net/ehea/ehea_main.c: In function 'ehea_driver_sysfs_add':
drivers/net/ehea/ehea_main.c:2812: error: 'struct device_driver' has no member named 'kobj'
drivers/net/ehea/ehea_main.c:2815: error: 'struct device_driver' has no member named 'kobj'
drivers/net/ehea/ehea_main.c:2818: error: 'struct device_driver' has no member named 'kobj'
drivers/net/ehea/ehea_main.c: In function 'ehea_driver_sysfs_remove':
drivers/net/ehea/ehea_main.c:2830: error: 'struct device_driver' has no member named 'kobj'


-Olof
