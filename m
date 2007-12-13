Return-Path: <linux-kernel-owner+w=401wt.eu-S1761453AbXLMM3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761453AbXLMM3j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 07:29:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761093AbXLMM31
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 07:29:27 -0500
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:44671 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757955AbXLMM3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 07:29:24 -0500
Message-ID: <47611EAF.4080806@linux.vnet.ibm.com>
Date: Thu, 13 Dec 2007 17:29:43 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>,
       Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Badari Pulavarty <pbadari@gmail.com>, rsa@us.ibm.com
Subject: Re: 2.6.24-rc5-mm1 kobject changes broken with hvcs driver on powerpc
 - regression
References: <20071213024050.7d6e5f3e.akpm@linux-foundation.org>
In-Reply-To: <20071213024050.7d6e5f3e.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The kernel build fails with following error message

drivers/char/hvcs.c: In function 'hvcs_open':
drivers/char/hvcs.c:1180: error: wrong type argument to unary exclamation mark
make[2]: *** [drivers/char/hvcs.o] Error 1
make[2]: *** Waiting for unfinished jobs....

This driver was broken in 2.6.24-rc4-mm1 either on powerpc, and the discussion
has been going on at

http://lkml.org/lkml/2007/12/5/141
http://lkml.org/lkml/2007/12/7/280
-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
