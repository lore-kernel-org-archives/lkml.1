Return-Path: <linux-kernel-owner+w=401wt.eu-S1756873AbZC2MCE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756873AbZC2MCE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 08:02:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755780AbZC2MBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 08:01:51 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39597 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755424AbZC2MBu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 08:01:50 -0400
Message-ID: <49CF632A.7070906@redhat.com>
Date: Sun, 29 Mar 2009 15:01:46 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Joerg Roedel <joerg.roedel@amd.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] Support for GB pages in KVM
References: <1238164319-16092-1-git-send-email-joerg.roedel@amd.com> <20090328214008.GB4694@amt.cnet>
In-Reply-To: <20090328214008.GB4694@amt.cnet>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marcelo Tosatti wrote:
> On Fri, Mar 27, 2009 at 03:31:52PM +0100, Joerg Roedel wrote:
>   
>> Hi,
>>
>> this patchset extends the KVM MMU implementation to support 1GB pages as
>> supported by AMD family 16 processors. These patches enable support for
>> 1 GB pages with Nested Paging. Support for these pages in the shadow
>> paging code was also developed but does not run stable yet. The patch
>> for shadow-paging support is not included in this series and will be
>> sent out seperatly.
>>     
>
> Looks generally sane. I'm not sure its even worthwhile to support
> GBpages with softmmu, because the chance of finding an area without
> shadowed (write protected) pages is much smaller than with 2MB pages.
>   

If the guest uses 1GB pages in userspace, then these pages would not 
have any write protected subpages.

-- 
error compiling committee.c: too many arguments to function

