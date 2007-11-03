Return-Path: <linux-kernel-owner+w=401wt.eu-S1759109AbXKBT3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759109AbXKBT3a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 15:29:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754693AbXKBT3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 15:29:23 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:26139 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbXKBT3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 15:29:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:organization:x-mailer:mime-version:content-type:content-transfer-encoding:from;
        b=fbDOVypu7hfRlSJaYa1l0ThcWAaVl1zTY2mODhbEM7dtCqpoWABco1Y/A8GwGHLmGgBTfLW8hNU/vKEhVh6W7IXcf4WuQjfa2BECMSvQM3pjTCfbC99azqNbnf0h6l+XLBrrxMFx6sZBvwMTW7pmLyYCrc45psd9sd/MKWFt5z8=
Date: Fri, 2 Nov 2007 20:29:31 -0700
To: Linux-arm <linux-arm-kernel@lists.arm.linux.org.uk>
Cc: linux-main <linux-kernel@vger.kernel.org>
Subject: [BUG] : kernel/built-in.o(.text+0x18db4):kernel/workqueue.c:823:
 undefined reference to `.L343'
Message-Id: <20071102202931.deb09211.Kristoffer.ericson@gmail.com>
Organization: JLime
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

Haven't found anyone reporting this. Taken from the very latest linux-2.6.git pull.

dnsdomainname: Unknown host
  UPD     include/linux/compile.h
  CC      init/version.o
  LD      init/built-in.o
  LD      .tmp_vmlinux1
kernel/built-in.o(.text+0x18db0): In function `destroy_workqueue':
kernel/workqueue.c:823: undefined reference to `.L342'
kernel/built-in.o(.text+0x18db4):kernel/workqueue.c:823: undefined reference to `.L343'
make: *** [.tmp_vmlinux1] Error 1
