Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752564Ab0CLHlY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 02:41:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7257 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751104Ab0CLHlX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 02:41:23 -0500
Message-ID: <4B99F01A.2020103@redhat.com>
Date: Fri, 12 Mar 2010 09:41:14 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Alexander Graf <agraf@suse.de>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/18][RFC] Nested Paging support for Nested SVM (aka NPT-Virtualization)
References: <1267643541-451-1-git-send-email-joerg.roedel@amd.com> <20100304144255.GA26657@amt.cnet> <20100304155820.GA6019@amd.com>
In-Reply-To: <20100304155820.GA6019@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2010 05:58 PM, Joerg Roedel wrote:
>> You probably need to include a flag in base_role to differentiate
>> between l1 / l2 shadow tables (say if they use the same cr3 value).
>>      
> Not sure if this is necessary. It may be necessary when large pages come
> into play. Otherwise the host npt pages are distinguished by the shadow
> npt pages by the direct-flag.
>    

Hm, I think that direct maps for the same gfn can be shared.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

