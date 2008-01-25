Return-Path: <linux-kernel-owner+w=401wt.eu-S1757509AbYAYUhK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757509AbYAYUhK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 15:37:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753697AbYAYUg5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 15:36:57 -0500
Received: from gw.goop.org ([64.81.55.164]:39362 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753636AbYAYUg5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 15:36:57 -0500
Message-ID: <479A4867.9040302@goop.org>
Date: Fri, 25 Jan 2008 12:36:55 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: compile error in current git
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When compiling current git with CONFIG_BLOCK disabled, I'm seeing this 
compile error:

  CC      drivers/base/core.o
/home/jeremy/hg/xen/paravirt/linux/drivers/base/core.c: In function ‘device_add_class_symlinks’:
/home/jeremy/hg/xen/paravirt/linux/drivers/base/core.c:655: error: ‘part_type’ undeclared (first use in this function)
/home/jeremy/hg/xen/paravirt/linux/drivers/base/core.c:655: error: (Each undeclared identifier is reported only once
/home/jeremy/hg/xen/paravirt/linux/drivers/base/core.c:655: error: for each function it appears in.)
/home/jeremy/hg/xen/paravirt/linux/drivers/base/core.c: In function ‘device_remove_class_symlinks’:
/home/jeremy/hg/xen/paravirt/linux/drivers/base/core.c:728: error: ‘part_type’ undeclared (first use in this function)
make[4]: *** [drivers/base/core.o] Error 1

    J
