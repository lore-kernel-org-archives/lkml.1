Return-Path: <linux-kernel-owner+w=401wt.eu-S1751668AbZHAOBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751668AbZHAOBp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 10:01:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751307AbZHAOBo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 10:01:44 -0400
Received: from main.gmane.org ([80.91.229.2]:35730 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368AbZHAOBo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 10:01:44 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Jack Byer <ojbyer@usa.net>
Subject: Extremely slow IO with a PCMCIA CompactFlash adapter
Followup-To: gmane.linux.kernel
Date: Sat, 01 Aug 2009 09:02:22 -0500
Message-ID: <h51hro$p6j$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: ppp-70-244-161-110.dsl.rcsntx.swbell.net
User-Agent: KNode/0.99.01
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have an old digital camera that stores its pictures on a 340 MB IBM 
microdrive. I am trying to transfer to pictures from the camera to my 
computer but can not find the special non-standard USB cable. The 
camera did come with a CompactFlash to PCMCIA adapter, so tried 
connecting it to my laptop. I was able to install the correct modules 
and mount the drive, but accessing it is very slow (5.0 kBps read / 
3.8 kBps write). Is this expected behavior? Is there any setup I am 
missing that would make this faster?

Kernel version is 2.6.30.3

pccardctl ls:

Socket 0 Bridge:        [yenta_cardbus]         (bus ID: 0000:00:0a.0)
Socket 0 Device 0:      [pata_pcmcia]           (bus ID: 0.0)

pccardctl info:

PRODID_1="IBM"
PRODID_2="microdrive"
PRODID_3=""
PRODID_4=""
MANFID=00a4,0000
FUNCID=4

time output to write a 1 MB file to the drive:

real    4m29.476s
user    0m0.000s
sys     0m0.000s

time output to read a 1 MB file from the drive:

real    3m25.600s
user    0m0.000s
sys     0m0.000s


