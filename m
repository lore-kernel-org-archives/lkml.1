Return-Path: <linux-kernel-owner+w=401wt.eu-S1752972AbZF2JJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752972AbZF2JJu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 05:09:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751680AbZF2JJm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 05:09:42 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:62529 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484AbZF2JJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 05:09:42 -0400
Message-ID: <4A4884D6.3090404@monstr.eu>
Date: Mon, 29 Jun 2009 11:09:42 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>, Arnd Bergmann <arnd@arndb.de>,
       benh@kernel.crashing.org,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       David Miller <davem@davemloft.net>, linux@arm.linux.org.uk
Subject: Move of_node_to_nid to generic location
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I have on my list one task which needs to be discuss with you.
I look at of_node_to_nid for non NUMA systems. I think we should
move this function to asm-generic/topology.h.

This function is used for powerpc, sparc, microblaze (and maybe future arm?)

Arnd what do you think?

Michal

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
