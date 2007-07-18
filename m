Return-Path: <linux-kernel-owner+w=401wt.eu-S932430AbXGRWzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932430AbXGRWzh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 18:55:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752660AbXGRWz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 18:55:28 -0400
Received: from mail1.ssmb.com ([199.67.179.103]:45426 "EHLO mail.citigroup.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752188AbXGRWz1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 18:55:27 -0400
X-Greylist: delayed 3889 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Jul 2007 18:55:27 EDT
Subject: RHEL4 kernel-2.6.9-42.0.2.EL
From: Andrew Li <andrew2.li@citi.com>
Reply-To: andrew2.li@citigroup.com
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Citigroup - CMB
Message-Id: <1184795428.4797.398.camel@al68835rh>
Mime-Version: 1.0
X-Mailer: Ximian Evolution 1.4.5 (1.4.5-20.el3) 
Date: Thu, 19 Jul 2007 07:50:29 +1000
X-OriginalArrivalTime: 18 Jul 2007 21:50:29.0766 (UTC) FILETIME=[A878A260:01C7C985]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

I have a strange problem with cron, it is doing a segfault every minute.
This problem happened out of the blue, according to authlog no users
have logged onto the system in between the time it last worked and the
time it began to fail.

The error messages from messages file is :
Jul 18 16:16:01 host100 kernel: crond[29540]: segfault at
0000000000000000 rip 0000000000000000 rsp 0000007fbffbf018 error 14

Looking at arch/x86_64/mm/fault.c, this happens when a user proc is
trying to access memory thats not in its memory map. But the address
reported in messages doesn't match /proc/pid/maps.

Does anyone have any idea what this might be?

Andrew
