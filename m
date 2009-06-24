Return-Path: <linux-kernel-owner+w=401wt.eu-S1755766AbZFXImS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755766AbZFXImS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 04:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754892AbZFXImB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 04:42:01 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36815 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752649AbZFXIl7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 04:41:59 -0400
Message-ID: <4A41E714.5070701@redhat.com>
Date: Wed, 24 Jun 2009 11:43:00 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <marcelo@kvack.org>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8 v3] KVM support for 1GB pages
References: <1245417389-5527-1-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1245417389-5527-1-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2009 04:16 PM, Joerg Roedel wrote:
> Hi,
>
> this is the third version of the patches for KVM to support 1GB pages. Changes
> to the last version include:
>
> 	- changed reporting of 1GB page support to userspace to use
> 	  SUPPORTED_CPUID ioctl
> 	- added support for 1GB pages to the software page walker code too
>
> This code still only can make use of 1GB pages with nested paging enabled. I
> will give the shadow paging code another debug round soon. Please comment or
> consider to apply these patches.
>
> Thanks,
>
> 	Joerg
>
> Shortlog:
>
> Joerg Roedel (8):
>        hugetlbfs: export vma_kernel_pagsize to modules
>        kvm: change memslot data structures for multiple hugepage sizes
>    

At Marcelo's suggestion I've applied the first two patches, to reduce 
your rebase load.

-- 
error compiling committee.c: too many arguments to function

