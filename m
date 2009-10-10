Return-Path: <linux-kernel-owner+w=401wt.eu-S1752081AbZJJD2O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081AbZJJD2O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 23:28:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750966AbZJJD2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 23:28:12 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:26893 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbZJJD2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 23:28:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=XiS15XMTsOL/qjO3piEFXODOYQ8GRtXpUy3cvqeVkkqOESRzUSQEZI6xRoVelM3Lq8
         G2ypJxDj19pMQmQf3Wt8udfKXElA4KHE6nBgWz8zvwNzdZtGm39r9MJHWqVqpOYDpHdU
         MBz8oclQMN1ImX39/4hlaz5L34F73OOjGRVqE=
Subject: ext4 filesystem corruption
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: linux-pm <linux-pm@lists.linux-foundation.org>
In-Reply-To: <1254863215.11577.23.camel@maxim-laptop>
References: <1254863215.11577.23.camel@maxim-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 10 Oct 2009 05:26:18 +0200
Message-Id: <1255145178.3542.9.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have more information on that issue.

First of all this isn't related to s2ram/disk.
Second, this happened here again 3 times.

Now kernel complains loudly about access to freed inode.

After a reboot fsck tells the following:

- Some directory entries point to freed inodes,
   Which means these files are gone, but I never deleted some of them

- Some inodes have shared blocks

- Some orpahaned inodes found

- Free block counts/bitmaps corrupted.

That all happens without any s2ram/disk cycle.

However, yet an unusual situation did happen today.
I had installed an update to mountall ubuntu package, and it hosed all
boot process.
I had to  reboot many times, and once did hold the power button for 4
seconds.

I also used often the SYSRQ+U/SYSRQ+B tool.

On the contrary, I did several s2disk cycles, and one did fail, but
there was no corruption.

I must say that until now, I had never seen any ext3/ext4 corruption,
even though there were many many crashes, power failures, forced
reboots, etc...

Best regards,
Maxim Levitsky

