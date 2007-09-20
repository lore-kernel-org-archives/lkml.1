Return-Path: <linux-kernel-owner+w=401wt.eu-S1755286AbXITNfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286AbXITNfT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 09:35:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752359AbXITNfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 09:35:08 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:49238 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbXITNfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 09:35:06 -0400
Date: Thu, 20 Sep 2007 19:07:52 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Mel Gorman <mel@skynet.ie>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org
Subject: 2.6.23-rc6-mm1: Build failures on ppc64_defconfig
In-Reply-To: <20070920132512.GF24105@skynet.ie>
Message-ID: <alpine.LFD.0.999.0709201903180.17093@enigma.security.iitk.ac.in>
References: <20070918011841.2381bd93.akpm@linux-foundation.org>
 <20070920132512.GF24105@skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 20 Sep 2007, Mel Gorman wrote:
> 
> allmodconfig on ppc64 fails to build with the following error

BTW ppc64_defconfig didn't quite like 2.6.23-rc6-mm1 either ...
IIRC I got build failures in:

drivers/ata/pata_scc.c
drivers/md/raid6int8.c
drivers/net/spider_net.c
drivers/net/pasemi_mac.c
drivers/pci/hotplug/rpadlpar_sysfs.c

I was in a hurry so didn't record the errors, just noted down the files
and disabled them from .config and continued building ... I'll get back
to fixing these up tonight (if you don't do that by then already).


Satyam
