Return-Path: <linux-kernel-owner+w=401wt.eu-S1754789AbZI3Pxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789AbZI3Pxm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 11:53:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754711AbZI3Pxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 11:53:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28932 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754557AbZI3Pxl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 11:53:41 -0400
Message-ID: <4AC37E81.8080104@redhat.com>
Date: Wed, 30 Sep 2009 05:51:29 -1000
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH v4: kvm 1/4] Code motion.  Separate timer intialization
 into an indepedent function.
References: <4AC1C59F.6010703@redhat.com> <1254260317-3490-1-git-send-email-zamsden@redhat.com> <4AC31AA5.4060609@redhat.com>
In-Reply-To: <4AC31AA5.4060609@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29/2009 10:45 PM, Avi Kivity wrote:
> On 09/29/2009 11:38 PM, Zachary Amsden wrote:
>> Signed-off-by: Zachary Amsden<zamsden@redhat.com>
>
>
> Looks good.
>
> Is anything preventing us from unifying the constant_tsc and !same 
> paths?  We could just do a quick check in the notifier, see the tsc 
> frequency hasn't changed, and return.

Actually, yes.  On constant_tsc processors, the processor frequency may 
still change, however the TSC frequency does not change with it.

I actually have both of these kinds of processors (freq changes with 
constant TSC and freq changes with variable TSC) so I was able to test 
both of these cases.

Zach
