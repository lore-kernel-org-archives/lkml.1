Return-Path: <linux-kernel-owner+w=401wt.eu-S1755395AbZG2NV1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395AbZG2NV1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 09:21:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754912AbZG2NV1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 09:21:27 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46852 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754684AbZG2NV0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 09:21:26 -0400
Message-ID: <4A704DEA.8040101@redhat.com>
Date: Wed, 29 Jul 2009 16:26:02 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/12] kvm/svm: cache nested intercepts
References: <1248872192-30881-1-git-send-email-joerg.roedel@amd.com> <1248872192-30881-9-git-send-email-joerg.roedel@amd.com> <4A704AFF.8070702@redhat.com> <20090729131319.GF18313@amd.com>
In-Reply-To: <20090729131319.GF18313@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2009 04:13 PM, Joerg Roedel wrote:
> On Wed, Jul 29, 2009 at 04:13:35PM +0300, Avi Kivity wrote:
>    
>> I don't see the benefit of this patch.  Accessing the cache is just
>> as expensive as accessing the real vmcb.
>>      
>
> The benefit is that we don't have to gup and map the nested vmcb just
> for checking who will take the intercept.

Makes sense.

> Another reason is that with
> this patch the behavior of nested SVM is more aligned to real hardware.
>    

Even more important, please put this in the commit log.

-- 
error compiling committee.c: too many arguments to function

