Return-Path: <linux-kernel-owner+w=401wt.eu-S1756242AbZDTPR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242AbZDTPR3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 11:17:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755441AbZDTPRV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 11:17:21 -0400
Received: from bay0-omc2-s21.bay0.hotmail.com ([65.54.246.157]:58982 "EHLO
	bay0-omc2-s21.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755398AbZDTPRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 11:17:20 -0400
X-Greylist: delayed 369 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Apr 2009 11:17:20 EDT
Message-ID: <BAY116-DAV13797E9A8B8D61B9322909B0760@phx.gbl>
X-Originating-IP: [82.23.42.123]
X-Originating-Email: [nodenet@hotmail.com]
From: "Wil" <nodenet@hotmail.com>
To: <linux-kernel@vger.kernel.org>
Cc: <nodenet@hotmail.com>
Subject: swap hint
Date: Mon, 20 Apr 2009 16:11:14 +0100
Message-ID: <91F5F240641E4FCBA9470D0CF1BCB7CC@fdidev001>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
Thread-Index: AcnByj7IqpLcewRpQxGAn5A6or0k0A==
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5579
X-OriginalArrivalTime: 20 Apr 2009 15:11:11.0021 (UTC) FILETIME=[3D25C5D0:01C9C1CA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've noticed that when running a VM such as qemu/vbox with approx 75% of
physical memory allocated with the default swappiness the swap file usage
will rise to approximately the same amount. Although setting swappiness to 0
seems to prevent this, running with this setting seems counter intuitive.
I'm wondering if the following is or would be possible

1. Provide page hint to prevent swapping of certain pages. This would
presumably allow applications running in the remaining host memory to use
the swap file efficiently.
2. Provide user space controls to prevent a certain process (or the memory
it allocates) being swapped. 

I'm not sure if memory ballooning will cover the above as I couldn't find
details of anything similar but would think that having some tunability for
special cases such as VMs would be useful especially if you could pick guest
performance / host memory usage on a per VM basis. I note that xen does seem
to do something along these lines as standard.

Will Wiseman



