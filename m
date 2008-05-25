Return-Path: <linux-kernel-owner+w=401wt.eu-S1753234AbYEYEVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234AbYEYEVw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 00:21:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751171AbYEYEVn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 00:21:43 -0400
Received: from tesla.comm.utoronto.ca ([128.100.11.1]:57370 "EHLO
	tesla.comm.toronto.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbYEYEVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 00:21:42 -0400
X-Greylist: delayed 1345 seconds by postgrey-1.27 at vger.kernel.org; Sun, 25 May 2008 00:21:42 EDT
Message-Id: <3CF690CE-DD01-4EE4-8B40-E2641D5C06AB@comm.utoronto.ca>
From: Alexander Karpenko <alexander@comm.utoronto.ca>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v919.2)
Subject: [PATCH] Fix fn key on Macbook Pro 4,1 and Macbook Air   (CC me on replies)
Date: Sat, 24 May 2008 23:59:01 -0400
X-Mailer: Apple Mail (2.919.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Summary: The fn key does not work on Macbook Pro 4,1 and Air,  
preventing the user from using the keyboard's media keys, volume keys,  
PgUp, PgDn, Home, End, Delete, and adjusting screen brightness.

Keywords: macbook, fn key, keyboard, hid, quirks

Kernel version: 2.6.24-16-generic

I've posted the patch to this bug report, which outlines the problem,  
debugging, and fix in more detail: https://bugs.launchpad.net/mactel-support/+bug/207127

The direct link to the patch is: http://launchpadlibrarian.net/14613817/fix_fn_key_on_macbookpro_4_1_and_mb_air.patch

Patch description:
The patch adds the device IDs of the keyboards (ANSI, ISO, JIS for MB  
Pro/Air) to drivers/hid/usbhid/hid-quirks.c.

Please CC me on replies, as I'm not subscribed to this mailing list.

Regards,

Alex
