Return-Path: <linux-kernel-owner+w=401wt.eu-S1161799AbXDXPUw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161799AbXDXPUw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 11:20:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161803AbXDXPUw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 11:20:52 -0400
Received: from wr-out-0506.google.com ([64.233.184.227]:29606 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161799AbXDXPUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 11:20:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=ntNNRaL7Wk6Icmq+m8LwkOodALLv7/mJMq/SpP/0sutbKM+4wkl+h6+J73LQ9JV+vAOJTq85li+VymqsqPtGiCnhmjDuYvDULqO/VisFhrYXMwTXMPFvrnui9ykwARdkZ5x0A8ymuj4u7uNBmh/Av7X9a94W7qIEeRp9sSiMS3k=
Message-ID: <65258a580704240820lbee4944t1adef1aeb92394ce@mail.gmail.com>
Date: Tue, 24 Apr 2007 17:20:49 +0200
From: "Vincent Vanackere" <vincent.vanackere@gmail.com>
To: "linux kernel mailing list" <linux-kernel@vger.kernel.org>,
       "Greg KH" <gregkh@suse.de>, "Tejun Heo" <htejun@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
Subject: [OOPS 2.6.21-rc7-mm1] kernel BUG at fs/sysfs/inode.c:272 (sysfs_drop_dentry)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm getting the following oops at boot with the latest -mm kernel :
---------------------------------------------------------------
kernel BUG at fs/sysfs/inode.c:272
...
EIP is at sysfs_drop_dentry+0x139/0x165

Call trace :
remove_dir
__sysfs_remove_dir
dput
kobject_del
device_del
...
------------------------------------------------------------------

A screenshot of the oops is available at request...

Best regards,
