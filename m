Return-Path: <linux-kernel-owner+w=401wt.eu-S1753223AbXHPUr3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223AbXHPUr3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 16:47:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754912AbXHPUrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 16:47:15 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57687 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752914AbXHPUrN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 16:47:13 -0400
Message-ID: <46C4B7BF.70305@redhat.com>
Date: Thu, 16 Aug 2007 16:46:55 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (Macintosh/20070509)
MIME-Version: 1.0
To: sk malik <srikrishanmalik@yahoo.co.in>
CC: LKML1 <linux-kernel@vger.kernel.org>
Subject: Re: Self healing in linux ?
References: <666676.51583.qm@web7614.mail.in.yahoo.com>
In-Reply-To: <666676.51583.qm@web7614.mail.in.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

sk malik wrote:
> Solaris 10 people are talkin a lot about the
> predictive self healing thing.
> 
> Do we have something similar planned/going on for
> linux. Or there is no use of this tecnology ;)

Doing this in-kernel would violate the separation of policy and 
mechanism.  There's nothing wrong with providing the hooks necessary for 
userspace to do this, but it's generally userspace's responsibility to 
decide what should be done when a possible problem is detected.  I'm 
aware of software that does predictive migration with mdadm when smartd 
detects a problem.  Getting this into users' hands is a distro/vendor 
problem, not a kernel development problem.

That said, if you can think of some additional hooks that would really 
be beneficial to userspace monitoring tools, by all means send in patches.

	-- Chris
