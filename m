Return-Path: <linux-kernel-owner+w=401wt.eu-S1759250AbYB1OgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759250AbYB1OgT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 09:36:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753101AbYB1OgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 09:36:06 -0500
Received: from an-out-0708.google.com ([209.85.132.241]:35391 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752AbYB1OgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 09:36:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:content-type:content-transfer-encoding;
        b=nsNw9gTwmX9fNiwsUZZQB22AxY7JTSUsObA63w+H564GfpXV4jrP2V8oPaD2xRR91xPPffhSoaH8m+84bILdxhDLv0keJASrjPPiHBEbTCKPi/VkmEqiQR4TU4Atf09UKn8bpvZUxDT8BBMJOOqadckSag7gtudB7t80kf3pTWw=
Message-ID: <47C6C828.5040601@gmail.com>
Date: Thu, 28 Feb 2008 08:41:44 -0600
From: YM Yen <yminyen@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Walking User mode pages
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

I am a newbie to Linux kernel, so please forgive me if the question is
stupid.

To understand the swapping system, I decided to write a module to scan 
every task_struct using for_each_process() checking whether or not the 
page pointed by the pte is swapped out. To get the linear address 
address of the pte, I did something similar to "pgd_offset << 
PGDIR_SHIFT + pud_offset << PUD_SHIFT + pmd_offset << PMDSHIFT + 
pte_offset << PAGE_SHIFT". The offset for each level is simply the 
iteration of the walking of the table ranging from 0 to PTRS_PER_(PGD, 
PUD, PMD, PTE) depending on the table. However, the result of the 
calculation doesn't match anything in the /proc/<pid>/maps.

Is this to be expected? If that's the case, how can I find out what's in 
the swap file. Thanks in advance.

YM
