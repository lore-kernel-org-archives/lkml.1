Return-Path: <linux-kernel-owner+w=401wt.eu-S967687AbXILQbA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967687AbXILQbA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 12:31:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967403AbXILQat
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 12:30:49 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:47976 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966994AbXILQas (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 12:30:48 -0400
Message-ID: <46E81433.5070702@garzik.org>
Date: Wed, 12 Sep 2007 12:30:43 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>, Marcel Holtmann <marcel@holtmann.org>,
       maxk@qualcomm.com
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [2.6.23-rc6] i386 build breakage on current git
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Platform i386 seems to be missing struct compat_timeval, which causes 
the i386 allmodconfig build to break in current -git:

net/bluetooth/hci_sock.c: In function ‘hci_sock_cmsg’:
net/bluetooth/hci_sock.c:352: error: storage size of ‘ctv’ isn’t known
net/bluetooth/hci_sock.c:352: warning: unused variable ‘ctv’
make[2]: *** [net/bluetooth/hci_sock.o] Error 1

