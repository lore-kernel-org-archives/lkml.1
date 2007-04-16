Return-Path: <linux-kernel-owner+w=401wt.eu-S1030664AbXDPOdq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030664AbXDPOdq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 10:33:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030666AbXDPOdq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 10:33:46 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:24312 "EHLO
	pd3mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030664AbXDPOdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 10:33:45 -0400
Date: Mon, 16 Apr 2007 08:33:26 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: 4GB Physical. Less than 3GB in Linux.
In-reply-to: <fa.wZS4ieAkOMvNOj61QiUn9aS+YeM@ifi.uio.no>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Message-id: <46238936.3060501@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.wZS4ieAkOMvNOj61QiUn9aS+YeM@ifi.uio.no>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Chua wrote:
> I've noticed that with 4GB physical ram, I'm only see 3098000 MB on
> the Dell 745, and 3107056MB on the IBM X60s.
> 
> I've tested with CONFIG_HIGHMEM4G=y, CONFIG_HIGHMEM64G=y,
> CONFIG_X86_PAE=y, but nothing makes any difference.

Chipset limitation. It uses up most of the MMIO region above 3GB 
preventing RAM from being mapped there, and doesn't support remapping 
the covered RAM to above 4GB. Nothing the kernel can do about it.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

