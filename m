Return-Path: <linux-kernel-owner+w=401wt.eu-S1761683AbYBLHks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761683AbYBLHks (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 02:40:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761559AbYBLHki
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 02:40:38 -0500
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:45437 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759795AbYBLHkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 02:40:36 -0500
Message-ID: <47B14D52.6050404@linux.vnet.ibm.com>
Date: Tue, 12 Feb 2008 13:10:02 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
CC: LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Richard Henderson <rth@twiddle.net>, tony.luck@intel.com,
       anton@samba.org, paulus@samba.org, rusty@rustcorp.com.au
Subject: [BUID_FAILURE] regression from 2.6.24-git18 to 2.6.25-rc1-git1 on
 section type conflict psmouse-base
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This build failure is seen on the powerpc from the 2.6.24-git18 kernel and is still visible
in the 2.6.25-rc1-git1.

drivers/input/mouse/psmouse-base.c:44: error: __param_proto causes a section type conflict
drivers/input/mouse/psmouse-base.c:44: error: __param_proto causes a section type conflict
make[3]: *** [drivers/input/mouse/psmouse-base.o] Error 1
make[2]: *** [drivers/input/mouse] Error 2
make[1]: *** [drivers/input] Error 2

The patch http://lkml.org/lkml/2008/2/8/514 seems to have not taken into 2.6.25-rc1 and 
2.6.25-rc1-git(s). Is there any new patch i am missing out.
-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
