Return-Path: <linux-kernel-owner+w=401wt.eu-S1757163AbZEUXdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757163AbZEUXdT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 19:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754712AbZEUXdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 19:33:05 -0400
Received: from tundra.namei.org ([65.99.196.166]:52581 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755509AbZEUXdE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 19:33:04 -0400
Date: Fri, 22 May 2009 09:32:39 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Eric Paris <eparis@redhat.com>
cc: linux-kernel@vger.kernel.org, zohar@linux.vnet.ibm.com,
       safford@watson.ibm.com
Subject: Re: [PATCH] IMA: Minimal IMA policy and boot param for TCB IMA
 policy
In-Reply-To: <20090521194706.5050.93139.stgit@dhcp231-142.rdu.redhat.com>
Message-ID: <alpine.LRH.2.00.0905220932260.6348@tundra.namei.org>
References: <20090521194706.5050.93139.stgit@dhcp231-142.rdu.redhat.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 May 2009, Eric Paris wrote:

> The IMA TCB policy is dangerous.  A normal use can use all of a system's
> memory (which cannot be freed) simply by building and running lots of
> executables.  The TCB policy is also nearly useless because logging in as root
> often causes a policy violation when dealing with utmp, thus rendering the
> measurements meaningless.

Applied to 
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next

-- 
James Morris
<jmorris@namei.org>
