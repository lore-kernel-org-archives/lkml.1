Return-Path: <linux-kernel-owner+w=401wt.eu-S934521AbYBHKdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934521AbYBHKdZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 05:33:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933143AbYBHKdG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 05:33:06 -0500
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:55549 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761139AbYBHKdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 05:33:05 -0500
Message-ID: <47AC2FDB.7080104@linux.vnet.ibm.com>
Date: Fri, 08 Feb 2008 16:02:59 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: [BUILD_FAILURE] 2.6.24-git18 build fails section type conflict psmouse-base
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The 2.6.24-git18 kernel build fails on the power machine with following message

drivers/input/mouse/psmouse-base.c:44: error: __param_proto causes a section type conflict
drivers/input/mouse/psmouse-base.c:44: error: __param_proto causes a section type conflict
make[3]: *** [drivers/input/mouse/psmouse-base.o] Error 1
make[2]: *** [drivers/input/mouse] Error 2
make[1]: *** [drivers/input] Error 2
make: *** [drivers] Error 2

this failure was reported earlier http://lkml.org/lkml/2007/9/22/64

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
