Return-Path: <linux-kernel-owner+w=401wt.eu-S1754417AbYFHIBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417AbYFHIBV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 04:01:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754151AbYFHIBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 04:01:05 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:19750 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132AbYFHIBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 04:01:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=p7JNryp+9vdWISY26ZYbHrkjUaRSn2/uaCkFLmrrftDO0b2DXKBBRkAqk2uSjMO/KR
         KXYXXIm/kNPkRj0jPRqyxBzShWgVx/ekQSZKjw8GaiatzVNZAX5TXljDw8Pj4o/BcOAq
         GySsO/ZN42DtNr7tsad/1ypI5v9+bvKMKN/pQ=
Message-ID: <484B91B9.5060204@gmail.com>
Date: Sun, 08 Jun 2008 16:00:57 +0800
From: RuoMu Hu <huruomu@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: linux-serial@vger.kernel.org, linux-net@vger.kernel.org
Subject: Create proc entry under /proc/sys/kernel
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Is it possible to create a proc entry under /proc/sys/kernel directly by 
create_proc_read_entry in the way shown below?

test_pde = create_proc_read_entry("/proc/sys/kernel/test", 0, NULL,
                                    test_read_proc, NULL);
if (test_pde == NULL) {
    printk(KERN_ERR "Failed to create the test proc file.\n");
    return -ENOMEM;
}

I'm using this in my kernel module but create_proc_read_entry always 
returns fail, while there's no problem creating proc entries directly 
under /proc.  The kernel source I'm building my kernel module against is 
2.6.25.4.

Any idea?


Thanks
Romu
