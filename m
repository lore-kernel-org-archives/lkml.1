Return-Path: <linux-kernel-owner+w=401wt.eu-S941300AbXGTQca@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941300AbXGTQca (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 12:32:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939090AbXGTQcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 12:32:23 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:30211 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S939054AbXGTQcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 12:32:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=jjqEVrOxuBzMrSGla0fb51rN34Dmbj1XGWN/UAym8beMwzp9OKF+ek0TmdGW25qlB3HgQSChT2Xh5hkfHI4sfbqVkk3gLAEIGiVJrUcHba/zs4oZa08cpYjZqmWyuQPhXYVybGpvlrCXw4mPCYZc5EQhoXcE/5DDeB/CVCz54U0=
Message-ID: <6bffcb0e0707200932p2b905e21g7970172ca7eb4da7@mail.gmail.com>
Date: Fri, 20 Jul 2007 18:32:21 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Subject: [broken-out-2007-07-20-00-22] kernel bug at kernel/params:570
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

This looks like a sysfs bug
http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/broken-out-2007-07-20-00-22/00003.jpg

l *kernel_param_sysfs_setup+0x75
0xc13c0894 is in kernel_param_sysfs_setup (kernel/params.c:570).
565             mk->mod = THIS_MODULE;
566             kobj_set_kset_s(mk, module_subsys);
567             kobject_set_name(&mk->kobj, name);
568             kobject_init(&mk->kobj);
569             ret = kobject_add(&mk->kobj);
570             BUG_ON(ret < 0);
571             param_sysfs_setup(mk, kparam, num_params, name_skip);
572             kobject_uevent(&mk->kobj, KOBJ_ADD);
573     }
574

http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/broken-out-2007-07-20-00-22/mm-config

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
