Return-Path: <linux-kernel-owner+w=401wt.eu-S934818AbXILQ3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934818AbXILQ3a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 12:29:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765692AbXILQ3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 12:29:23 -0400
Received: from rzcomm22.rz.tu-bs.de ([134.169.9.68]:47964 "EHLO
	rzcomm22.rz.tu-bs.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765613AbXILQ3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 12:29:22 -0400
Message-ID: <46E813F3.2040004@l4x.org>
Date: Wed, 12 Sep 2007 18:29:39 +0200
From: Jan Dittmer <jdi@l4x.org>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070828)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.23-rc6-git1 i386/allmodconfig broke
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Since -rc6:

- i386/allmodconfig: broke
     CC [M]  net/bluetooth/hci_core.o
     CC [M]  net/bluetooth/hci_conn.o
     CC [M]  net/bluetooth/hci_event.o
     CC [M]  net/bluetooth/hci_sock.o
   net/bluetooth/hci_sock.c: In function 'hci_sock_cmsg':
   net/bluetooth/hci_sock.c:352: error: storage size of 'ctv' isn't known
   net/bluetooth/hci_sock.c:352: warning: unused variable 'ctv'
   make[3]: *** [net/bluetooth/hci_sock.o] Error 1
   make[2]: *** [net/bluetooth] Error 2
   make[1]: *** [net] Error 2
   make: *** [_all] Error 2



Nice, that post rc6 patches aren't even tested with one of the most
common archs and configs :-(

Jan
