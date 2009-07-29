Return-Path: <linux-kernel-owner+w=401wt.eu-S1755496AbZG2N1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496AbZG2N1c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 09:27:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755475AbZG2N1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 09:27:31 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60518 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755204AbZG2N1a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 09:27:30 -0400
Message-ID: <4A704F5B.9000800@redhat.com>
Date: Wed, 29 Jul 2009 16:32:11 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/12] Nested SVM cleanups
References: <1248872192-30881-1-git-send-email-joerg.roedel@amd.com> <4A70492E.2080705@redhat.com> <20090729130944.GE18313@amd.com>
In-Reply-To: <20090729130944.GE18313@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2009 04:09 PM, Joerg Roedel wrote:
>> I seem to recall nested smp used to be broken.  Am I mistaken, or do
>> these patches fix rather than clean up?
>>      
>
> Nested SMP was broken in one of the early version of the nested SVM
> code. In the current upstream version it works quite well.
>    

In that case, the next interesting target is nested npt.  This may 
actually make nsvm perform well.  Any plans?

-- 
error compiling committee.c: too many arguments to function

