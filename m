Return-Path: <linux-kernel-owner+w=401wt.eu-S1755257AbXIRH0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257AbXIRH0r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 03:26:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754569AbXIRH0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 03:26:39 -0400
Received: from smtp1.Vir.com ([199.202.113.40]:34278 "EHLO smtp1.vir.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754560AbXIRH0j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 03:26:39 -0400
Message-ID: <46EF7DAD.3080502@soo.com>
Date: Tue, 18 Sep 2007 03:26:37 -0400
From: ben soo <lnx-kern@soo.com>
Reply-To: lnx-kern@soo.com
User-Agent: Thunderbird 1.5.0.9 (X11/20070111)
MIME-Version: 1.0
To: Kernel Mailing list <linux-kernel@vger.kernel.org>
Subject: VGA text console display problem with kernel 2.6.23-rc5/6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

i've 2 servers with old PCI VGA cards, one using X86_64 kernel 
version 2.6.23-rc5 and one with i386 kernel version 2.6.23-rc6,
both wired into the same CRT via a KVM switch.

No matter what text screen size i set on both these machines (using 
resizecons) the shell line where i type in commands is past the 
bottom of the screen, invisible.

Another box connected to the same KVM displays fine, and it runs 
2.6.22-rc7.

i also have a box running kernel 2.6.23-rc5 where the console 
display is fine: it uses a GeForce 8500 PCI-E vidcard driving a LCD 
screen.

