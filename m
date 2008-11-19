Return-Path: <linux-kernel-owner+w=401wt.eu-S1754509AbYKSSc1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509AbYKSSc1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 13:32:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753493AbYKSScS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 13:32:18 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:37113 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441AbYKSScS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 13:32:18 -0500
Date: Wed, 19 Nov 2008 19:32:16 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: jdike@addtoit.com
Subject: uml: using hostfs as rootfs is not working
Message-ID: <alpine.LNX.1.10.0811191930090.4486@fbirervta.pbzchgretzou.qr>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


as per Documentation/uml/*txt, I issued the following to get a direct 
hostfs:

	./linux ubd0=/tftpboot/linux

(/tftpboot/linux/sbin/init exists), but the UM kernel only gives:

Failed to open '/home/tftpboot/linux', errno = 21
ubda: Can't open "/home/tftpboot/linux": errno = 21
List of all partitions:
6200               4 ubda driver: uml-blkdev

So either UML lost some functionality sometime, or the documentation is 
incorrect.
