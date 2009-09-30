Return-Path: <linux-kernel-owner+w=401wt.eu-S1754839AbZI3P4D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839AbZI3P4D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 11:56:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754773AbZI3P4C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 11:56:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25135 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754739AbZI3P4A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 11:56:00 -0400
Message-ID: <4AC37F92.2090502@redhat.com>
Date: Wed, 30 Sep 2009 17:56:02 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Zachary Amsden <zamsden@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH v4: kvm 1/4] Code motion.  Separate timer intialization
 into an indepedent function.
References: <4AC1C59F.6010703@redhat.com> <1254260317-3490-1-git-send-email-zamsden@redhat.com> <4AC31AA5.4060609@redhat.com> <4AC37E81.8080104@redhat.com>
In-Reply-To: <4AC37E81.8080104@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/30/2009 05:51 PM, Zachary Amsden wrote:
>> Is anything preventing us from unifying the constant_tsc and !same 
>> paths?  We could just do a quick check in the notifier, see the tsc 
>> frequency hasn't changed, and return.
>
>
> Actually, yes.  On constant_tsc processors, the processor frequency 
> may still change, however the TSC frequency does not change with it.
>
> I actually have both of these kinds of processors (freq changes with 
> constant TSC and freq changes with variable TSC) so I was able to test 
> both of these cases.

If the API allows us to query the tsc frequency, it would simply return 
the same values in all cases, which we'd ignore.

-- 
error compiling committee.c: too many arguments to function

