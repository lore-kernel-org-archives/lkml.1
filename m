Return-Path: <linux-kernel-owner+w=401wt.eu-S934040AbXLPNkE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934040AbXLPNkE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 08:40:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761144AbXLPNjz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 08:39:55 -0500
Received: from web52909.mail.re2.yahoo.com ([206.190.49.19]:37543 "HELO
	web52909.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751512AbXLPNjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 08:39:54 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=gqdaOF+GsdfLdKek5qgsDQGU9lEmeuJ/EGLk10wOQe7cYp7ePMRiIz0cUPvrCx5ck4VPOOf2q4SOFB4AkxUS8GF3iFIsbRttVpJM5ECIYx9VOEPetlZXCgx0j9oDNNvCAD4Zbc1c69MKUAjGT3AoSjmPJm0ahMd9ivDh6DItV6Y=;
X-YMail-OSG: ghGOGSkVM1l9stq9omXtEput3jvPKUZKHI7DQa7vDEZrTqOfCre9wBjUv5Ym1noWHn_.qNFcst0jjrk9c7656vI100pGx_4eJxxOHPKykgqtnoxa8jYQ.fTTJXFqOQ--
Date: Sun, 16 Dec 2007 13:39:53 +0000 (GMT)
From: Chris Rankin <rankincj@yahoo.com>
Subject: [BUG] NMI Watchdog alert with Linux 2.6.23.11
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <541882.9201.qm@web52909.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

My dual Xeon P4 (HT enabled), 2 GB RAM box crashed last night while playing World of Warcraft
under Wine (Mesa 7.1, Radeon 9550 card). This is what appeared on the serial console.

Cheers,
Chris

BUG: NMI Watchdog detected LOCKUP on CPU3, eip c0102aac, registers:
CPU:    3
EIP:    0060:[<c0102aac>]    Not tainted VLI
EFLAGS: 00000246   (2.6.23.11 #1)
EIP is at default_idle+0x2c/0x3e
eax: 00000000   ebx: c0102a80   ecx: 01cef000   edx: 002694b3
esi: 00000003   edi: 00000000   ebp: 00000000   esp: f7c0bfac
ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
Process swapper (pid: 0, ti=f7c0b000 task=f7c23540 task.ti=f7c0b000)
Stack: c010239e 0702080b 00000000 00000000 00000000 00000000 00000000 00000000 
       00000000 00000000 00000000 00000000 000000d8 00000000 00000000 00000000 
       00000000 00000000 00000000 00000000 00000000 
Call Trace:
 [<c010239e>] cpu_idle+0x97/0xcc
 =======================
Code: 3d 28 39 35 c0 00 75 32 80 3d 85 ad 30 c0 00 74 29 89 e0 25 00 f0 ff ff 83
 60 0c fd 0f ae f0 89 f6 fa 8b 40 08 a8 04 75 04 fb f4 <eb> 01 fb 89 e0 25 00 f0
 ff ff 83 48 0c 02 c3 f3 90 c3 55 57 56 



      __________________________________________________________
Sent from Yahoo! Mail - a smarter inbox http://uk.mail.yahoo.com

