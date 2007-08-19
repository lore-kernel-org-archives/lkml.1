Return-Path: <linux-kernel-owner+w=401wt.eu-S1757189AbXHSWqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757189AbXHSWqQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 18:46:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751671AbXHSWqE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 18:46:04 -0400
Received: from server2.corp.notserp.com ([64.71.152.20]:1613 "EHLO
	server2.corp.notserp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188AbXHSWqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 18:46:02 -0400
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <522E9EF6-9A3A-464A-9CE8-C5D263A08B43@linuxmontreal.com>
Reply-To: netdev@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Eric Preston <developer@linuxmontreal.com>
Subject: Re: Marvell 88E8056 gigabit ethernet controller 
Date: Sun, 19 Aug 2007 18:45:55 -0400
To: linux-kernel@vger.kernel.org
X-Mailer: Apple Mail (2.752.3)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


 > The working board has a different version of the Marvell chip:

 > $ grep Marvell working-MB
 > 04:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8056  
PCI-E Gigabit Ethernet Controller (rev 14)
 > $ grep Marvell broken-MB
 > 04:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8056  
PCI-E Gigabit Ethernet Controller (rev 12)

Just to add a bit more information, I've just build up a GA-965P-DS3  
with a Q6600 and the onboard Marvell doesn't seem to be working  
either with 2.6.21.3, 2.6.23-rc3 or a recent gentoo-sources kernel.

$ grep Marvell lspci
03:00.0 Ethernet controller: Marvell Technology Group Ltd. Unknown  
device 4364 (rev 12)

I've attached the lspci -vvv. I haven't had a chance to do much  
investigation since I just threw an 10/100 in for the time being. Let  
me know if I can provide any assistance in diagnosing or testing.

-E

---
Eric Preston, RHCA, RHCSS, RHCE
Open Source Software Consultant // Administrator, Developer, Trainer
514-312-7072

