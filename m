Return-Path: <linux-kernel-owner+w=401wt.eu-S1752846AbYJYDa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846AbYJYDa2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 23:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751900AbYJYDaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 23:30:20 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:50166 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831AbYJYDaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 23:30:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=F8N78dJSje/IE4U7/zQ9qYJWq7IZygOzFotvXKyOQC2NVycUbTcSFJkLkGeG1+qSO3
         M+KVyHbsrJTekTbYTAX9uQ9OALI8Dn1sHvnWZ7U18PjIbPftB6JeZO+NnhMY63Awgky7
         Xg3RVfMmxpNQiUZ3C9/9WLMOskwqlowX32+hQ=
From: Joe Damato <ice799@gmail.com>
To: linux-x86_64@vger.kernel.org, linux-newbie@vger.kernel.org,
       kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Joe Damato <ice799@gmail.com>
Subject: [PATCH 00/12] x86: Cleanup idt, gdt/ldt/tss structs  
Date: Fri, 24 Oct 2008 20:15:20 -0700
Message-Id: <1224904532-9586-1-git-send-email-ice799@gmail.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

This is my first submission to the kernel, so (beware!) please let me know if I can make any improvements on these patches.

I attempted to clean up the x86 structs for 32bit cpus that store IDT/LDT/GDT data by removing the fields labeled "a" and "b" in favor of more descriptive field names. I added some macros and went through the kernel cleaning up the various places where "a" and "b" were used.

I tried building my kernel with my .config and then also did a make allyesconfig build to help ensure I found everything that was using the old structure names. I also tried a few grep patterns. Hopefully I got everyone out.


Thanks,
Joe Damato
