Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754392Ab0BHJYu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 04:24:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:65455 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753088Ab0BHJYt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 04:24:49 -0500
Message-ID: <4B6FD852.90806@redhat.com>
Date: Mon, 08 Feb 2010 11:24:34 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Joerg Roedel <joerg.roedel@amd.com>, David Woodhouse <dwmw2@infradead.org>,
       kvm@vger.kernel.org, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/11] kvm: Change kvm_iommu_map_pages to map large pages
References: <1264678682-30655-1-git-send-email-joerg.roedel@amd.com> <1264678682-30655-7-git-send-email-joerg.roedel@amd.com> <20100128222455.GA26274@amt.cnet> <4B6EAF8B.9090707@redhat.com> <20100207184133.GA3387@amt.cnet>
In-Reply-To: <20100207184133.GA3387@amt.cnet>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2010 08:41 PM, Marcelo Tosatti wrote:
>
>> How could it return a bad_page?  The whole thing is called for a valid slot.
>>      
> Userspace can pass a valid slot with a read-only vma, for example.
>    

Oh yes, or without a vma at all.

-- 
error compiling committee.c: too many arguments to function

