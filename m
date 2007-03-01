Return-Path: <linux-kernel-owner+w=401wt.eu-S1752388AbXCANhP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752388AbXCANhP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 08:37:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752397AbXCANhP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 08:37:15 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:57998 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752388AbXCANhN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 08:37:13 -0500
Date: Thu, 1 Mar 2007 19:05:43 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: menage@google.com
Cc: ebiederm@xmission.com, sam@vilain.net, akpm@linux-foundation.org,
       pj@sgi.com, dev@sw.ru, xemul@sw.ru, serue@us.ibm.com,
       containers@lists.osdl.org, winget@google.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] resource control file system - aka containers on top of nsproxy!
Message-ID: <20070301133543.GK15509@in.ibm.com>
Reply-To: vatsa@in.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul,
	Based on some of the feedback to container patches, I have
respun them to avoid the "container" structure abstraction and instead use
nsproxy structure in the kernel. User interface (which I felt was neat
in your patches) has been retained to be same.

What follows is the core (big) patch and the cpu_acct subsystem to serve
as an example of how to use it. I suspect we can make cpusets also work
on top of this very easily.

Oh and since most of the code is serving the purpose of being a
filesystem, I have renamed the patch to be a resource control file
system - rcfs!


-- 
Regards,
vatsa
