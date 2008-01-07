Return-Path: <linux-kernel-owner+w=401wt.eu-S1754573AbYAGD2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573AbYAGD2k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 22:28:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753181AbYAGD2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 22:28:33 -0500
Received: from comsmtp2.singnet.com.sg ([165.21.101.75]:40628 "EHLO
	comsmtp2.singnet.com.sg" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753095AbYAGD2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 22:28:32 -0500
To: linux-kernel@vger.kernel.org
Subject: Size of kernel halts startup
Message-ID: <1199676509.47819c5deaf60@discus.singnet.com.sg>
Date: Mon, 07 Jan 2008 11:28:29 +0800 (SGT)
From: cksim <cksim@singnet.com.sg>
Reply-To: cksim@singnet.com.sg
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
User-Agent: SingNet WebMail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Yesterday, I have encountered an issue when the kernel size is more than 1.3MB.

Info on problem encountered as follows:
1) I am using Atmel AT91SAM9261 part. Circuit similar to that of AT91SAM9261EK
evaluation board.

2) I am booting the kernel through NFS. Bootloader
used is UBoot 1.1.5. Kernel used is 2.6.23.1

3) For the past weeks, the kernel size was about 1.3MB and kernel bootup over NFS was fine.

4) Yesterday, I have done a menuconfig and turned on some drivers (USB HID and I2C).  This resulted in a kernel size of about 1.4MB.

5) Booting up this 1.4MB kernel over NFS causes a register dump to appear and the system is halted.

Is this issue related to the size of the kernel or it is due to some conflict in memory ?

If it is related to size of kernel, how can the size be increased so as to resolve this issue ?

Appreciate any help and advises.

Thanks in advance.

Sim CK
