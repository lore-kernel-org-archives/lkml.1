Return-Path: <linux-kernel-owner+w=401wt.eu-S1754401AbZGFStr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754401AbZGFStr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 14:49:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753415AbZGFStk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 14:49:40 -0400
Received: from mail-pz0-f193.google.com ([209.85.222.193]:53753 "EHLO
	mail-pz0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343AbZGFStj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 14:49:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=hVjOIDUTx/SqfDhSkGwJSUnAb657K3XvoywTq3BI23qlzTamG2rIMs/XcnfeCfJQkn
         OHYfQLHP3DZBHVLTH2YE+lzx3hq07rkcc7i+mC98+QYAbkGwLsKPud1xGJwsUsyEEiQk
         0jV55ASpXQx5HwBI8XCGMQ70bOPF77GV4srgk=
MIME-Version: 1.0
Date: Tue, 7 Jul 2009 00:12:56 +0530
Message-ID: <dad209ce0907061142j1497a7bl8dc6cc99cf982ad0@mail.gmail.com>
Subject: Problem with 'vtop' command in crash utility
From: Rasha Eqbal <rasha.eq@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

I have installed Wubi-8.10 on my Intel x86 32-bit system. The kernel
version I am working with is 2.6.28. On running crash when I use the
vtop command, I get the following error:

read error: physical address <address> type: page table

The steps I follow are:

$crash vmlinux
crash> vm

from here I pick out the start address of any one vm region, say
<vm_start> and do:

crash> vtop <vm_start>

This is where I get the error.

This I found is being caused due to the inability of the kernel to
directly access the page tables which are present in high memory for
kernel version 2.6. So I shifted the page tables to normal memory by
turning off CONFIG_HIGHPTE. Now I am able to run vtop. But I want to
have the page tables in high memory itself. Is there a way to
successfully run vtop command with this setting i.e. page tables in
high memory.

Thanks in advance for your help.


--
Rasha Eqbal
IIIrd Yr Undergraduate Student
Department of Computer Science and Engineering
IIT Kharagpur, India
