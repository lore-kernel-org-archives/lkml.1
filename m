Return-Path: <linux-kernel-owner+w=401wt.eu-S1753176AbZADAxL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176AbZADAxL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 19:53:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750805AbZADAw5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 19:52:57 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:38722 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbZADAw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 19:52:56 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <49600856.8030500@s5r6.in-berlin.de>
Date: Sun, 04 Jan 2009 01:52:38 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.18) Gecko/20081116 SeaMonkey/1.1.13
MIME-Version: 1.0
To: linux1394-devel@lists.sourceforge.net
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] firewire: cdev: fix documentation of FW_CDEV_IOC_GET_INFO
References: <tkrat.c7deb6ca39b7041e@s5r6.in-berlin.de>
In-Reply-To: <tkrat.c7deb6ca39b7041e@s5r6.in-berlin.de>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:
> The FW_CDEV_IOC_GET_INFO ioctl looks at client->device->config_rom, not
> at the local node's config ROM.
> 
> We could fix the implementation or the documentation.  I believe the way
> how it is currently implemented is more useful than the way how it is
> currently documented, hence let's change only the documentation.
...
>   * struct fw_cdev_get_info - General purpose information ioctl
...
>   * @rom:	If non-zero, address of a buffer to be filled by a copy of the
> - *		local node's configuration ROM
> + *		device's configuration ROM

Of course libdc1394 uses the ABI already as implemented, not as documented.
-- 
Stefan Richter
-=====-==--= ---= --=--
http://arcgraph.de/sr/
