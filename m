Return-Path: <linux-kernel-owner+w=401wt.eu-S965744AbXIGOPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965744AbXIGOPe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 10:15:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965280AbXIGOPZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 10:15:25 -0400
Received: from mtagate2.uk.ibm.com ([195.212.29.135]:21926 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965041AbXIGOPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 10:15:25 -0400
Message-ID: <46E15CB4.9040508@fr.ibm.com>
Date: Fri, 07 Sep 2007 16:14:12 +0200
From: Daniel Lezcano <dlezcano@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [SYSFS - 2.6.23-rc5-git1 ] device_rename: sysfs_create_symlink failed
 (-17)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

when using the 2.6.23-rc5-git1 kernel and trying to change a network 
device name, I have the following error:

device_rename: sysfs_create_symlink failed (-17)

That comes from drivers/base/core.c : 1261

I know anything about sysfs, so no much help to give... :(

I don't know if this is a bug, but my code use device_rename, check the 
return value and fails. I will ignore it, but it seems not to be a 
correct behavior to have such error.

Easy to reproduce:
	load a dummy network driver => dummy0
	change its name with : ip link set name foo0 dev dummy0

Thanks.
  --Daniel
