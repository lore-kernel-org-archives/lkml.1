Return-Path: <linux-kernel-owner+w=401wt.eu-S1753483AbYJPFU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483AbYJPFU3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 01:20:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750986AbYJPFUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 01:20:21 -0400
Received: from mirror.looking-glass.spherevision.org ([70.85.129.236]:36983
	"EHLO octagon.spherevision.org" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750920AbYJPFUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 01:20:21 -0400
X-Greylist: delayed 1698 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Oct 2008 01:20:21 EDT
Subject: [2.6.27] constant early exception on boot
From: Rodney Gordon II <meff@spherevision.org>
To: linux-kernel@vger.kernel.org
Cc: meff@spherevision.org
Content-Type: text/plain
Date: Wed, 15 Oct 2008 23:52:22 -0500
Message-Id: <1224132742.7417.1.camel@ghreen.sphere>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Recently with the release of 2.6.27 I have tried this on my main machine
(in the form of vanilla 2.6.27 final, Ubuntu Intrepid Beta 2.6.27-rc,
and RIPLinux 6.9 2.6.27 final  ----  all AMD64) and I have been getting
a pretty regular early exception on my hardware. I will include as much
information as I have collected.

System:
Asus P5QL-PRO
Intel Q6600
4GB RAM (memtest'ed)
GeForce 8800GT 512M

Panic:
Kernel alive
Kernel really alive
PANIC: early exception 0e rip 10:ffffffff8072f305 error 0 cr2
ffffffffff341000

Working boot dmesg:
http://spherevision.org/sync/kernel/ubuntu-8.04-working-dmesg.log

lspci
http://spherevision.org/sync/kernel/lspci-vvnn.log

I am available for details/testing/etc for whatever it takes to clean
this error up and get it to boot on my hardware. 

Similar page off launchpad.net of error on boot of Intrepid Beta on some
with similar outputs of early exceptions: 
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/54020

Please CC me as I am off list.

Thanks

