Return-Path: <linux-kernel-owner+w=401wt.eu-S933705AbXHHHjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933705AbXHHHjq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 03:39:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756793AbXHHHjg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 03:39:36 -0400
Received: from rv-out-0910.google.com ([209.85.198.184]:38049 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853AbXHHHje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 03:39:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=FpkFIR0yvl0xpPoeAh7oxzcwtO5jCFyFz2G2mkvuIMxGQBb93s5IDSwalIa8sN302vbcBhZKu/MuGpQElO8hqgRsUNd4zENg8YcrRtdWprTsdkYYZ7u/ZqUCbypvqgr2LCfWyWXZMEI86gbcGaaCCStwnlRROlsf3Ej6azte5so=
Message-ID: <a8e1da0708080039w1deed062hf5920e1257eb1cbb@mail.gmail.com>
Date: Wed, 8 Aug 2007 07:39:33 +0000
From: "Dave Young" <hidave.darkstar@gmail.com>
To: rdunlap@xenotime.net
Subject: two questions about the boot_delay
Cc: "Dave Jones" <davej@codemonkey.org.uk>,
       LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I have tried the "slow down printk" , and I have two questions.

1. why it depends the DEBUG_KERNEL? Sometimes we only need boot_delay
to see the printk infomations.  How about set it as a standalone
config option?

2. In My system if I boot with boot_delay=200 the early part of
booting will be very slow, eapecially at the very beginning (after the
compressing  and start kernel, it nearly stop here many minutes).

And I wonder if we can simply use mdelay in the boot_delay_msec(). I
tested the mdelay , and the result is more accurate.

Regards
dave
