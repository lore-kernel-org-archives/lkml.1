Return-Path: <linux-kernel-owner+w=401wt.eu-S1762603AbXHQMtM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762603AbXHQMtM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 08:49:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758619AbXHQMs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 08:48:56 -0400
Received: from web38906.mail.mud.yahoo.com ([209.191.125.112]:30482 "HELO
	web38906.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758617AbXHQMsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 08:48:55 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 Aug 2007 08:48:55 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=K7t1Gw4vOIASAlLw/GQNV/eFwebeJYqh75m8eF37dK00Rv8TuyEekPrh8vw7p0tVXtdVHQ2xBEJIeXpXI5ojCRVB8LF1M51ont6uA69bY2K3BN1M+4PL4g218F5492nLkif2vqsFdGVcsjRU6zF2IOuqdK3J6qBVnwLoDxmwfZ4=;
X-YMail-OSG: NwasPPsVM1lKmQn3DkkilanDpMYsldcpEdCXIVGrj0t2RnTPfcMtZAWpQMYSwKsMVvMid99pQucYnWONqQLMi9Y7AqYP7AEkELyWCB8BkYsHrK17R_s9gKfeKhEk.Q--
Date: Fri, 17 Aug 2007 05:42:13 -0700 (PDT)
From: Kevin E <kevin360@yahoo.com>
Subject: Marvell 88E8056 gigabit ethernet controller
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <424491.59139.qm@web38906.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

	I've read where the onboard Marvell lan controller on
some Gigabyte boards don't work.  I've got two systems
using the same Gigabyte board, on one the LAN works on
the other it dies like described by others.  Here's
the systems:


Working system:
Gigabyte 965P-DS3 rev 3.3  (BIOS F10)
Core2 Q6600
2GB Corsair XMS2 memory
kernel 2.6.22.3

lspci for LAN controller:
04:00.0 Ethernet controller: Marvell Technology Group
Ltd. 88E8056 PCI-E Gigabit Ethernet Controller (rev
14)


Broken system:
Gigabyte 965P-DS3 rev 3.3  (BIOS F10)
Core2 E4400
2GB Corsair XMS2 memory
kernel 2.6.22.3

lspci for LAN controller:
03:00.0 Ethernet controller: Marvell Technology Group
Ltd. Unknown device 4364 (rev 12)


	The BIOS for the two systems are setup the same and
the config for the kernels are the same too.  I've
actually tried taking the kernel from the working
system and booting it on the broken one but still the
LAN dies after a couple of seconds.  The working
system has one card plugged in (nvidia based PCI-X
video card), I've taken that card and plugged into the
broken system, booted the same kernel, and it still
dies after a while.

	I will gladly provide any info needed if it can help
in getting this chipset working on the Gigabyte
boards.

	Thanks,
	Kevin


       
____________________________________________________________________________________
Be a better Heartthrob. Get better relationship answers from someone who knows. Yahoo! Answers - Check it out. 
http://answers.yahoo.com/dir/?link=list&sid=396545433
