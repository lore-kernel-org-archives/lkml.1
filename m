Return-Path: <linux-kernel-owner+w=401wt.eu-S1754112AbZGAMYA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112AbZGAMYA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 08:24:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751514AbZGAMXw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 08:23:52 -0400
Received: from fw08.mobotixserver.de ([213.183.84.168]:34982 "EHLO
	fw08.mobotixserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbZGAMXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 08:23:52 -0400
From: Daniel Kabs <daniel.kabs@gmx.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: adjusting lowmem_reserve_ratio on an embedded system?
Date: Wed, 1 Jul 2009 14:23:52 +0200
User-Agent: KMail/1.9.10
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907011423.52798.daniel.kabs@gmx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

in tracing a low on memory situation on an embedded system I came across 
the Documentation/sysctl/vm.txt. There it is advised to change the 
lowmem_reserve_ratio on systems running without swap.

I wonder if this applies for an embedded system running with 256MByte RAM 
and no swap which is using only one memory zone (ZONE_NORMAL)? I guess 
no.


To understand what the parameter means I read the relevant section from 
vm.txt and came across the terms "lowmem zone" and "lower zones" 
and "lowmem memory". I feel dumb. I could not find a concept of "lower 
zones" (or "upper" zones).  What exactly do they mean?

Cheers
Daniel
