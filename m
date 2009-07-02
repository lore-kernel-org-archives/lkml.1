Return-Path: <linux-kernel-owner+w=401wt.eu-S1755280AbZGBOk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280AbZGBOk2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 10:40:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754248AbZGBOkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 10:40:17 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34880 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753217AbZGBOkQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 10:40:16 -0400
Message-ID: <4A4CC742.9020400@redhat.com>
Date: Thu, 02 Jul 2009 17:42:10 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mst@redhat.com,
       davidel@xmailserver.org
Subject: Re: [KVM PATCH v8 1/3] KVM: Fix races in irqfd using new eventfd_kref_get
 interface
References: <20090701160208.3615.99153.stgit@dev.haskins.net> <20090701160902.3615.39426.stgit@dev.haskins.net> <4A4CC14C.1000905@redhat.com> <4A4CC3B4.7060109@novell.com>
In-Reply-To: <4A4CC3B4.7060109@novell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/2009 05:27 PM, Gregory Haskins wrote:
>
>    
>> Please split the eventfd.c hunk into a separate patch.  When preparing
>> the 2.6.32 submission, I'll fold that into the patch into its
>> antipatch and they'll disappear.
>>
>>      
> Ok, but note that that means I should probably split 1/3 back out into
> 1/5 (prepare), 2/5 (eventfd hunk), 3/5 (fix irqfd) again like I had in
> v7 so that the series is bisectable.  Is that ok?
>
>    

Sure.

-- 
error compiling committee.c: too many arguments to function

