Return-Path: <linux-kernel-owner+w=401wt.eu-S1754669AbYJUUXe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669AbYJUUXe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 16:23:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754305AbYJUUXW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 16:23:22 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:62496 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754149AbYJUUXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 16:23:21 -0400
Message-ID: <48FE3A34.5040105@freescale.com>
Date: Tue, 21 Oct 2008 15:23:16 -0500
From: Timur Tabi <timur@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.16) Gecko/20080702 SeaMonkey/1.1.11
MIME-Version: 1.0
To: Dan Williams <dan.j.williams@intel.com>
CC: linux-kernel@vger.kernel.org, Kumar Gala <kumar.gala@freescale.com>
Subject: Re: Best method for sending messages to user space?
References: <48FE1741.1000502@freescale.com>	 <e9c3a7c20810211114w5be330d3h35f859b4ea8f8af7@mail.gmail.com>	 <48FE30D8.6050705@freescale.com> <e9c3a7c20810211316i13610410h5ec022b55c248c6a@mail.gmail.com>
In-Reply-To: <e9c3a7c20810211316i13610410h5ec022b55c248c6a@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Williams wrote:

> fd = open("/sys/block/md0/md/array_state");
> do {
> 	read(buf, fd, len);
> 	act_on_message(buf);
> 	select(...); /* wait for next sysfs_notify event */
> 	lseek(fd, 0, SEEK_SET); /* seek back so we can read the new state */
> } while (1);

I meant from the kernel side.  I added a call to sysfs_notify(), and I didn't
see any sysfs entries being created, so I presume I need to set up sysfs before
I call sysfs_notify(), but I can't figure out what that setup is.

-- 
Timur Tabi
Linux kernel developer at Freescale
