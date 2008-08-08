Return-Path: <linux-kernel-owner+w=401wt.eu-S1752606AbYHHO2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606AbYHHO2j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 10:28:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751299AbYHHO23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 10:28:29 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:63615 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbYHHO21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 10:28:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=LADOWCjQTVVFv6RTMdxW8gKiuc8tjJ1puIUHeC6RrdmUUJkQVqUyzdVebQSgmjE0vb
         yblYnSYZ+TplydKbQvibEeB8k8rqrOx5ZBysXFnEYaXho24oEz2q+yRi7v9U6NRRhnEb
         0cB7aOBb5NCS90gmcXtKjLKj1oHApj4TZ/0GE=
Message-ID: <a4423d670808080728s68d351a6l869152f5908eb6d8@mail.gmail.com>
Date: Fri, 8 Aug 2008 18:28:26 +0400
From: "Alexander Beregalov" <a.beregalov@gmail.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: 2.6.26-rc: SPARC: Sun Ultra 10 can not boot
Cc: kernel-testers@vger.kernel.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080808.041814.41687650.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a4423d670808080314weed9178o9f9ef52803a68501@mail.gmail.com>
	 <20080808.033811.129671951.davem@davemloft.net>
	 <a4423d670808080356r6573102am8a1eb9dcc83910c8@mail.gmail.com>
	 <20080808.041814.41687650.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/8/8 David Miller <davem@davemloft.net>:
> Please also double check that you patched the kernel with my
> fix correctly.  I used your exact config, on the exact same
> kind of system, reproducing the exact same hang, and it goes
> away with my fix.
>
It can be a different compiler version,
but I tried 4.3.1 and 4.1.2 with the same result.

After I removed CON_BOOT warnings apear after
Locking API testsuite:
<..>
Good, all 218 testcases passed!
Dentry cache hash table entries: 131072 (order: 7, 1048576 bytes)
Inode-cache hash table entries: 65536 (order: 6, 524288 bytes)
=== here ===
Memory: 1019600k available (2672k kernel code, 1264k data, 128k init)
[fffff80000000000,000000003ff46000]
SLUB: Genslabs=13, HWalign=32, Order=0-2, MinObjects=8, CPUs=1, Nodes=1
Calibrating delay using timer specific routine.. 884.33 BogoMIPS (lpj=4421694)

Is it possible that lockdep messages did not appear when CON_BOOT was
in the flags?

Hope it will help.
