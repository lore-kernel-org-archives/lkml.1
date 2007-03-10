Return-Path: <linux-kernel-owner+w=401wt.eu-S933465AbXCJHAf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933465AbXCJHAf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 02:00:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933506AbXCJHAe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 02:00:34 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:49502 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933465AbXCJHAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 02:00:31 -0500
Message-ID: <45F2578E.3060907@vmware.com>
Date: Fri, 09 Mar 2007 23:00:30 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>
Subject: PATCH: Fix VMI and COMPAT_VDSO for 2.6.21
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

VMI is broken under COMPAT_VDSO, as Xen and other non hardware assisted 
hypervisors will be.  I have been working on a fix for this which works 
for older glibcs that panic when the new relocatable VDSO is used.  
However, I believe at this time that the fix is going to be too radical 
to consider at this stage in the release of 2.6.21.  We don't expect 
this config option to be turned on by vendors for new distributions, so 
at this point we are willing to drop support for it when VMI is compiled 
in, and work on a patch for 2.6.22 which more fully addresses the problem.

Please apply, thanks.

Zach
