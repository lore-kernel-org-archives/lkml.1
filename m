Return-Path: <linux-kernel-owner+w=401wt.eu-S1756305AbXFLMvh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756305AbXFLMvh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 08:51:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755404AbXFLMva
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 08:51:30 -0400
Received: from cg-p07-fb.rzone.de ([81.169.146.215]:17389 "EHLO
	cg-p07-fb.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755357AbXFLMva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 08:51:30 -0400
From: Oliver Neukum <oliver@neukum.org>
To: linux-kernel@vger.kernel.org
Subject: cannot set IP for ethernet
Date: Tue, 12 Jun 2007 14:41:13 +0200
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706121441.13561.oliver@neukum.org>
X-RZG-AUTH: kN+qSWxTQH+Xqix8Cni7tCsVYhPCm1GPE5pUNaoG1wTinqjVVl1GKJZKNFH/0WQQjVkh
X-RZG-CLASS-ID: mo07
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

with 2.6.22-rc4-git2 I am getting errors when setting IP for ethernet
interfaces:

ioctl(4, SIOCSIFADDR, 0x7fff94931600)   = -1 ENOBUFS (No buffer space available)

The error is independant of the interface. It happens to all interfaces.
There's nothing in the syslog.

valisk:/home/oliver # uname -a
Linux valisk 2.6.22-rc4-git2-default #3 SMP Tue Jun 12 13:27:54 CEST 2007 x86_64 x86_64 x86_64 GNU/Linux

	Regards
		Oliver
