Return-Path: <linux-kernel-owner+w=401wt.eu-S1757720AbYDWS7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757720AbYDWS7U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 14:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753617AbYDWS7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 14:59:12 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:48635 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753313AbYDWS7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 14:59:11 -0400
Date: Wed, 23 Apr 2008 14:59:05 -0400 (EDT)
From: Jeff Arnold <jbarnold@MIT.EDU>
To: linux-kernel@vger.kernel.org
Subject: A system for rebootless kernel security updates
Message-ID: <alpine.DEB.1.00.0802221606520.21343@vinegar-pot.mit.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I've put together an automatic system for applying kernel security patches 
to the Linux kernel without rebooting it, and I wanted to share this 
system with the community in case others find it useful or interesting.

Here's the summary:  The system takes as input a kernel security patch 
(which can be a unified diff taken directly from Linus' GIT tree) and the 
source code corresponding to the running kernel, and it automatically 
creates a set of kernel modules to perform the update.  The running kernel 
does not need to have been customized in advance in any way.  To be fully 
automatic, the system cannot be used to apply patches that introduce 
semantic changes to data structures, but most Linux kernel security 
patches don't make these kinds of changes.  I've evaluated the system 
against various kernel versions and security vulnerabilities, and the 
system can automatically apply 84% of the significant kernel security 
patches from May 2005 through December 2007.

I've been pursuing this project because I don't like dealing with reboots 
whenever a new local kernel security vulnerability is discovered.  The 
rebootless update practices/systems that are already out there require 
manually constructing an update (through a process that can be tricky and 
error-prone), and they tend to have other disadvantages as well (such as 
requiring a custom kernel, not handling inline functions properly, etc). 
This new system works on existing kernels, and it simply takes a unified 
diff as input and does the rest on its own.

The system's website is http://web.mit.edu/ksplice.

The GIT repository, code tarball, and binary tarballs are available here:
http://web.mit.edu/ksplice/ksplice.git
http://web.mit.edu/ksplice/dist/ksplice-src.tar.gz
http://web.mit.edu/ksplice/dist/ksplice-bin-i386.tar.gz
http://web.mit.edu/ksplice/dist/ksplice-bin-x86_64.tar.gz

A document describing how the system works is available here: 
http://web.mit.edu/ksplice/doc/ksplice.pdf

Any feedback would be appreciated.

Jeff Arnold
jbarnold@mit.edu
