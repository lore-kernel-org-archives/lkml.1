Return-Path: <linux-kernel-owner+w=401wt.eu-S1756192AbZDUQVp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192AbZDUQVp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 12:21:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752275AbZDUQVe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 12:21:34 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35938 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752127AbZDUQVe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 12:21:34 -0400
Message-ID: <49EDF287.9020908@redhat.com>
Date: Tue, 21 Apr 2009 19:21:27 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Anthony Liguori <anthony@codemonkey.ws>
CC: Huang Ying <ying.huang@intel.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v2] Add MCE support to KVM
References: <1239953345.6842.3.camel@yhuang-dev.sh.intel.com> <49E9F7BE.4090904@codemonkey.ws> <49EAE334.9020803@redhat.com> <49EDF057.9060501@codemonkey.ws>
In-Reply-To: <49EDF057.9060501@codemonkey.ws>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anthony Liguori wrote:
>
> Regardless of the KVM interface for this, to go upstream to QEMU, this 
> needs a TCG implementation which means the logic must be duplicated in 
> userspace.  In particular, this is because a user-visible command is 
> being introduced in the monitor.

Definitely.

>
> So Avi, regardless of what interface is chosen for KVM, can you hold 
> off applying these patches until there is a TCG implementation?  
> Otherwise, we'll be playing catchup between kvm-userspace and upstream 
> QEMU forever.

I have a feeling we will anyway, but that's no reason to increase the 
gap.  Huang, can you generate a version for qemu/tcg?

-- 
error compiling committee.c: too many arguments to function

