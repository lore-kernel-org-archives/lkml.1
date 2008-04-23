Return-Path: <linux-kernel-owner+w=401wt.eu-S1757182AbYDWVhc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757182AbYDWVhc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 17:37:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752478AbYDWVhZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 17:37:25 -0400
Received: from smtp5-g19.free.fr ([212.27.42.35]:44572 "EHLO smtp5-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752333AbYDWVhY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 17:37:24 -0400
Date: Wed, 23 Apr 2008 23:37:22 +0200
From: FD Cami <francois.cami@free.fr>
To: Jeff Arnold <jbarnold@MIT.EDU>
Cc: linux-kernel@vger.kernel.org
Subject: Re: A system for rebootless kernel security updates
Message-ID: <20080423233722.646012fb@olorin>
In-Reply-To: <alpine.DEB.1.00.0802221606520.21343@vinegar-pot.mit.edu>
References: <alpine.DEB.1.00.0802221606520.21343@vinegar-pot.mit.edu>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Apr 2008 14:59:05 -0400 (EDT)
Jeff Arnold <jbarnold@MIT.EDU> wrote:

> Hello,

Hi Jeff,

> I've put together an automatic system for applying kernel security patches 
> to the Linux kernel without rebooting it, and I wanted to share this 
> system with the community in case others find it useful or interesting.

(reading on)

> Here's the summary:  The system takes as input a kernel security patch 
> (which can be a unified diff taken directly from Linus' GIT tree) and the 
> source code corresponding to the running kernel, and it automatically 
> creates a set of kernel modules to perform the update.  The running kernel 
> does not need to have been customized in advance in any way.  To be fully 
> automatic, the system cannot be used to apply patches that introduce 
> semantic changes to data structures, but most Linux kernel security 
> patches don't make these kinds of changes.  I've evaluated the system 
> against various kernel versions and security vulnerabilities, and the 
> system can automatically apply 84% of the significant kernel security 
> patches from May 2005 through December 2007.

Awesome. Please note that reading this, I thought at first that the set of
kernel modules were in fact, updated kernel modules (i.e. necessary unloading/
loading of modules) which I understood was not the case after reading your
PDF. After checking with a friend of mine, he understood it like I did.
Perhaps :

- it automatically creates a set of kernel modules to perform the update.
+ it automatically creates a set of kernel modules containing the kernel
+ functions touched by the update, and arranges for the running kernel to
+ use the new functions from now on.

would be better.

> I've been pursuing this project because I don't like dealing with reboots 
> whenever a new local kernel security vulnerability is discovered.  The 
> rebootless update practices/systems that are already out there require 
> manually constructing an update (through a process that can be tricky and 
> error-prone), and they tend to have other disadvantages as well (such as 
> requiring a custom kernel, not handling inline functions properly, etc). 
> This new system works on existing kernels, and it simply takes a unified 
> diff as input and does the rest on its own.

It really looks like a non intrusive way of achieving superior uptime.

Congrats ! 

Best,

Francois
