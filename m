Return-Path: <linux-kernel-owner+w=401wt.eu-S1752847AbYI0J4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847AbYI0J4R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 05:56:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752074AbYI0J4B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 05:56:01 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42127 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751741AbYI0J4B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 05:56:01 -0400
Message-ID: <48DE0336.2010703@redhat.com>
Date: Sat, 27 Sep 2008 12:56:06 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: inconsistent lock state. (kvm)
References: <20080927023002.GA28250@redhat.com>
In-Reply-To: <20080927023002.GA28250@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones wrote:
> I just triggered this with just modprobe kvm_intel ; rmmod kvm kvm_intel
>
> 	Dave
>
> =================================
> [ INFO: inconsistent lock state ]
> 2.6.26.3-29.fc9.x86_64.debug #1
> ---------------------------------
> inconsistent {hardirq-on-W} -> {in-hardirq-W} usage.
> Xorg/2680 [HC1[1]:SC0[0]:HE0:SE1] takes:
>  (kvm_lock){+-..}, at: [<ffffffffa0463ad6>] decache_vcpus_on_cpu+0x20/0xbd [kvm]
>   

This is sort of known, which is why decache_vcpus_on_cpu no longer exists.


-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

