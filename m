Return-Path: <linux-kernel-owner+w=401wt.eu-S965378AbXCFReX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965378AbXCFReX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 12:34:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965381AbXCFReX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 12:34:23 -0500
Received: from mail.tmr.com ([64.65.253.246]:58869 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965378AbXCFReW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 12:34:22 -0500
Message-ID: <45EDA6A3.7010109@tmr.com>
Date: Tue, 06 Mar 2007 12:36:35 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Linux Kernel mailing List <linux-kernel@vger.kernel.org>
Subject: CONFIG_SYSFS_DEPRECATED and similar issues
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Just a few comments on changes like this in general. Prompted by, but 
not otherwise related to the subject.

When any new feature in the kernel requires significant changes in 
userspace, attention should be given to documenting the user items which 
must change. Now "attention" doesn't mean handwaving b.s. like "user 
programs which depend on sysfs will need to be modified." It means a 
list of which common user features need to be updated and where to find 
new ones. That's what the whole Documentation directory is for, but it's 
rarely used for such a purpose.

In the most recent case, a user tool is needed which doesn't even exist 
as a release.

The other issue is to avoid "trap door" changes, which occur when a 
kernel change requires new user tools, and the user tools will not run 
with older kernels. That includes missing major features like having a 
display and being able to mount filesystems, even if the kernel is 
technically running. When there were stable and development kernel 
series that was not so much of an issue, now that every kernel is an 
adventure it would be nice to ensure that testing a new kernel is not an 
irrevocable step.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
