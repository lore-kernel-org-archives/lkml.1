Return-Path: <linux-kernel-owner+w=401wt.eu-S1753541AbZI3Ip0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541AbZI3Ip0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 04:45:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752819AbZI3IpZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 04:45:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17299 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752658AbZI3IpZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 04:45:25 -0400
Message-ID: <4AC31AA5.4060609@redhat.com>
Date: Wed, 30 Sep 2009 10:45:25 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Zachary Amsden <zamsden@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH v4: kvm 1/4] Code motion.  Separate timer intialization
 into an indepedent function.
References: <4AC1C59F.6010703@redhat.com> <1254260317-3490-1-git-send-email-zamsden@redhat.com>
In-Reply-To: <1254260317-3490-1-git-send-email-zamsden@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29/2009 11:38 PM, Zachary Amsden wrote:
> Signed-off-by: Zachary Amsden<zamsden@redhat.com>
>    


Looks good.

Is anything preventing us from unifying the constant_tsc and !same 
paths?  We could just do a quick check in the notifier, see the tsc 
frequency hasn't changed, and return.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

