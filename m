Return-Path: <linux-kernel-owner+w=401wt.eu-S1754070AbZGXTmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070AbZGXTmc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 15:42:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751259AbZGXTmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 15:42:32 -0400
Received: from office.neopsis.com ([78.46.209.98]:54389 "EHLO
	office.neopsis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbZGXTmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 15:42:31 -0400
X-Greylist: delayed 1992 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Jul 2009 15:42:31 EDT
Message-Id: <5A77D882-B628-4105-85A3-ADE423BBD9F8@dbservice.com>
From: Tomas Carnecky <tom@dbservice.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v935.3)
Subject: Show module version sysfs file for built-in modules?
Date: Fri, 24 Jul 2009 21:08:51 +0200
X-Mailer: Apple Mail (2.935.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some userspace tools check /sys/modules/XYZ/version to determine  
whether the required module is available and the version compatible  
with the userspace tool. But that sysfs file is not shown when the  
module is built into the kernel (as opposed being a loadable module).  
Is there a reason for that behavior? Or is there another way for  
userspace to check the presence and version of a module?
The userspace tool in question here is the open-iscsi daemon (iscsid)  
which checks /sys/modules/scsi_transport_iscsi/version and refuses to  
start if that file doesn't exist.

thanks
tom

