Return-Path: <linux-kernel-owner+w=401wt.eu-S933758AbYBMREU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933758AbYBMREU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 12:04:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933063AbYBMRDS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 12:03:18 -0500
Received: from www.tglx.de ([62.245.132.106]:54778 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933307AbYBMRDR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 12:03:17 -0500
Date: Wed, 13 Feb 2008 18:03:04 +0100
From: =?UTF-8?B?SGFucy1Kw7xyZ2Vu?= Koch <hjk@linutronix.de>
To: linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: UIO sysfs attributes broken in 2.6.25-rc1
Message-ID: <20080213180304.4ffa81e9@dilbert.local>
Organization: Linutronix
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In 2.6.25-rc1, there's a strange effect:
Although the map attributes "addr" and "size" show up correctly:

-r--r--r-- 1 root root 4096 2008-02-13 17:49 addr
-r--r--r-- 1 root root 4096 2008-02-13 17:49 size

you cannot access them, not even as root. Something like "cat addr"
fails with a no-permission-error. It works fine in 2.6.24-rc8.

This is probably related to this patch:

http://lkml.org/lkml/2008/1/25/149

Unfortunately, I signed-off that one, too... I checked if all sysfs
files appear, but didn't try to access them. Sorry.

Greg, any ideas?

Thanks,
Hans
