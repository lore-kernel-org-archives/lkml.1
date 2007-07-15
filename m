Return-Path: <linux-kernel-owner+w=401wt.eu-S1757274AbXGOKmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757274AbXGOKmU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 06:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759292AbXGOKlx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 06:41:53 -0400
Received: from smtp-100-sunday.nerim.net ([62.4.16.100]:62057 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757274AbXGOKlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 06:41:52 -0400
Date: Sun, 15 Jul 2007 12:42:32 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Tejun Heo <htejun@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: sysfs root link count broken in 2.6.22-git5
Message-ID: <20070715124232.4e371bf9@hyperion.delvare>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun, hi Greg,

I'm running 2.6.22-git5 and noticed that the link count of the sysfs
root is broken:

$ ls -ld /sys
drwxr-xr-x 2 root root 0 Jul 15 12:27 /sys

sysfs is mounted, the link count should be 11, and is with kernel
2.6.22.1. find(1) complains about the bad link count.

I suppose this is an unexpected side effect of the big sysfs changes
that went in 3 days ago. Do you have any idea what can be wrong and how
to fix it, or do you want me to perform a bisection?

Thanks,
-- 
Jean Delvare
