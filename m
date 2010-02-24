Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757912Ab0BXT60 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 14:58:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52482 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757889Ab0BXT6Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 14:58:24 -0500
Message-ID: <4B8584D5.8010303@redhat.com>
Date: Wed, 24 Feb 2010 21:58:13 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Alexander Graf <agraf@suse.de>, Marcelo Tosatti <mtosatti@redhat.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/11] KVM: SVM: Optimize nested svm msrpm merging
References: <1267034360-5907-1-git-send-email-joerg.roedel@amd.com> <1267034360-5907-12-git-send-email-joerg.roedel@amd.com> <402BABD5-304A-47EA-B35C-D0E3948BB27E@suse.de> <20100224193700.GE3168@amd.com>
In-Reply-To: <20100224193700.GE3168@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2010 09:37 PM, Joerg Roedel wrote:
>
>> Isn't there such a list around somewhere already? We really should
>> only keep this list once throughout the whole code. If necessary, just
>> create the list on the fly when bits get set in the msrpm.
>>      
> No, the list is hardcoded in 3 functions (as parameter of
> set_msr_interception). I think about a variant to do this with a single
> list. Probably I create a list of MSRs and check in
> set_msr_interceptionm for it.
>
>    

Or, have set_msr_interception() create the list of offsets.


-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

