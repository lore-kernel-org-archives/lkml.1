Return-Path: <linux-kernel-owner+w=401wt.eu-S1752986AbYI0K1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986AbYI0K1p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 06:27:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752144AbYI0K1h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 06:27:37 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41526 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752139AbYI0K1h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 06:27:37 -0400
Message-ID: <48DE0A90.4020002@redhat.com>
Date: Sat, 27 Sep 2008 13:27:28 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: james toy <unk.nown@unix.net>
CC: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 20080923-mmotm arch/x86/kvm/built-in.o: In function `kvm_dev_ioctl_check_extension':
References: <9f8af95f0809251429n289229beo80cf6ef3c5ef600c@mail.gmail.com>
In-Reply-To: <9f8af95f0809251429n289229beo80cf6ef3c5ef600c@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

james toy wrote:
> Noticed this break with virtualization enabled on the latest mmotm.
>
> arch/x86/kvm/built-in.o: In function `kvm_dev_ioctl_check_extension':
> (.text+0x6a71): undefined reference to `intel_iommu_found'
> make: *** [vmlinux] Error 1
> [bbs@raider zenmm]$
>   

This ought to be fixed already.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

