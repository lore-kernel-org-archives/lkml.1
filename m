Return-Path: <linux-kernel-owner+w=401wt.eu-S1752946AbZHTDEK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946AbZHTDEK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 23:04:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752038AbZHTDEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 23:04:09 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:9877 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbZHTDEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 23:04:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:content-transfer-encoding:message-id:content-type:to
         :from:subject:date:x-mailer;
        b=u9ivUh4huA3BwxGrmC33YfN5GZFATvdXILc2lW6WYuCXY/h3FUfATUqiZJ9PLSqz4d
         Lv3CInHdL7ATggtLhJ1MeRQ/xzPBMBi1FFP15htae0JB69bR+FuO4L1sSoOzyLo2pe/2
         ARF5Ss/euuW/s560PaBtd3DNdOp/oehWY3Sgs=
Mime-Version: 1.0 (Apple Message framework v749)
Content-Transfer-Encoding: 7bit
Message-Id: <E9D727BD-78FC-4D85-9841-34A8F41613BB@gmail.com>
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
To: linux-kernel@vger.kernel.org
From: Bowen <zbw1983@gmail.com>
Subject: ATI driver conflict with LOCK_STAT
Date: Thu, 20 Aug 2009 11:04:00 +0800
X-Mailer: Apple Mail (2.749)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All:

	I just found that I can't compile my ATI driver. I have downloaded a  
ATI driver from their web site, but I can't compile it successfully,  
it reported "FATAL: modpost: GPL-incompatible module fglrx.ko uses  
GPL-only symbol
'lock_acquire'",

	I found when I close LOCK_STAT, I can compiled ATI driver  
successfully. And I also try to remove GPL declaration from  
"lock_acquire, lock_release, rcu_lock_map, lockdep_init_map", I can  
also use ATI driver. So does anybody meet same problem? Should we  
remove GPL limitation from those functions in kernel? Or just make  
ATI driver conflict with LOCK_STAT?

Regards
Bowen

