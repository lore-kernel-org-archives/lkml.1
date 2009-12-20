Return-Path: <linux-kernel-owner+w=401wt.eu-S1753331AbZLTJ74@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331AbZLTJ74 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 04:59:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753045AbZLTJ7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 04:59:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27173 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752887AbZLTJ7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 04:59:54 -0500
Message-ID: <4B2DF597.6050106@redhat.com>
Date: Sun, 20 Dec 2009 11:59:51 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Zachary Amsden <zamsden@redhat.com>
CC: Joerg Roedel <joerg.roedel@amd.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: SVM: Adjust tsc_offset only if tsc_unstable
References: <1260789740-14847-1-git-send-email-joerg.roedel@amd.com> <4B2704B2.10709@redhat.com>
In-Reply-To: <4B2704B2.10709@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/2009 05:38 AM, Zachary Amsden wrote:
> On 12/14/2009 01:22 AM, Joerg Roedel wrote:
>> The tsc_offset adjustment in svm_vcpu_load is executed
>> unconditionally even if Linux considers the host tsc as
>> stable. This causes a Linux guest detecting an unstable tsc
>> in any case.
>> This patch removes the tsc_offset adjustment if the host tsc
>> is stable. The guest will now get the benefit of a stable
>> tsc too.
>>
> Hi Joerg, I have a much more comprehensive series of patches to 
> address this issue, please take a look.
>

Despite this, I've applied the patch to have this fix in while we review 
your patch set (haven't started yet, sorry - still recovering from 
nested vmx).

-- 
error compiling committee.c: too many arguments to function

