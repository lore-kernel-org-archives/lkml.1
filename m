Return-Path: <linux-kernel-owner+w=401wt.eu-S1030651AbXDPORy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030651AbXDPORy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 10:17:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030653AbXDPORy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 10:17:54 -0400
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:59996 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030651AbXDPORx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 10:17:53 -0400
Message-ID: <46238572.5050203@s5r6.in-berlin.de>
Date: Mon, 16 Apr 2007 16:17:22 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.2) Gecko/20070222 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Jeff Chua <jeff.chua.linux@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: 4GB Physical. Less than 3GB in Linux.
References: <b6a2187b0704160028x3f979dc3s1c9e18995f229782@mail.gmail.com>
In-Reply-To: <b6a2187b0704160028x3f979dc3s1c9e18995f229782@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Chua wrote:
> I've noticed that with 4GB physical ram, I'm only see 3098000 MB on
> the Dell 745, and 3107056MB on the IBM X60s.
> 
> I've tested with CONFIG_HIGHMEM4G=y, CONFIG_HIGHMEM64G=y,
> CONFIG_X86_PAE=y, but nothing makes any difference.
> 
> Tested on Linux 2.6.20, Linux 2.6.21-rc7.

The X60 most certainly contains a chipset which severely limits the
amount of accessible RAM due to issues with remapping of PCIe addresses.
 Intel explains it somewhere on their web presence.  A quick & lazy web
search turned this Intel paper up:
http://www.polywell.com/us/support/faq/4GB_Rev1.pdf
-- 
Stefan Richter
-=====-=-=== -=-- -==-=
http://arcgraph.de/sr/
