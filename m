Return-Path: <linux-kernel-owner+w=401wt.eu-S1751551AbXC0T31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751551AbXC0T31 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 15:29:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752306AbXC0T31
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 15:29:27 -0400
Received: from wx-out-0506.google.com ([66.249.82.234]:17814 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551AbXC0T30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 15:29:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:content-type:content-transfer-encoding;
        b=YpyjLF/KlrsQS66ivBthJj/8HHkLWv4oxDqwllgCPdhsOSe+fwEbldWc8Au52Ks4HH1t71vhJwv2+xExh8CIrtK/nYraEo1P1iDYWT806I+6L5cfl2IyFAlKVWwiIAaog957xWtMglQkBJAEETS1ily0h8NpAGrG2WZhOFltph4=
Message-ID: <4609708E.5090908@gmail.com>
Date: Tue, 27 Mar 2007 23:29:18 +0400
From: Ignatich <ignatich@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: reiser4 bugs in 2.6.21-rc4
Content-Type: text/plain; charset=windows-1251; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There are two bugs I found in current -mm reiser4 code.

1. Some files seem to be zeroed out randomly. Usually it's 
/lib/security/pam_limits.so and /lib/security/pam_deny.so. As 
fsck.reiser4 didn't find anything wrong I decided to create clean 
installation in vmware and see if this bug appears on newly formatted 
partition. It did.

2. Sometimes I get oppses in reiser4_do_readpage_extent. Assert codes 
are vs-1426 and nikita-2688. A patch was posted on namesys list to 
address this problem, but it didn't help.

Kernel: 2.6.21-rc4 with manually applied reiser4 patches from -mm. Arch: 
x86-64
