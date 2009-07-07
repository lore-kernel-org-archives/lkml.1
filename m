Return-Path: <linux-kernel-owner+w=401wt.eu-S1753711AbZGGFRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753711AbZGGFRT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 01:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751668AbZGGFRH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 01:17:07 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53067 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751056AbZGGFRG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 01:17:06 -0400
Message-ID: <4A52DA60.8040200@redhat.com>
Date: Tue, 07 Jul 2009 08:17:20 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, davidel@xmailserver.org
Subject: Re: [KVM PATCH v9 5/5] KVM: create irqfd-cleanup-wq on demand
References: <20090702153454.20186.99191.stgit@dev.haskins.net> <20090702153821.20186.9344.stgit@dev.haskins.net> <20090706155850.GA12399@redhat.com> <4A522050.7030200@novell.com> <20090706161444.GC12399@redhat.com> <4A52272A.2060101@novell.com> <20090706165045.GF12399@redhat.com> <4A524243.9020100@novell.com>
In-Reply-To: <4A524243.9020100@novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/06/2009 09:28 PM, Gregory Haskins wrote:
> Michael S. Tsirkin wrote:
>    
>> On Mon, Jul 06, 2009 at 12:32:42PM -0400, Gregory Haskins wrote:
>>
>>      
>>> For the record, I would have rather just used my originally proposed
>>> slow-work thread instead of all this ;)
>>>
>>>        
>> Or just keep the idle thread around, it's not a big deal.
>>
>>
>>      
>
> If everyone is fine with that, lets do that then.  It's certainly the
> simplest solution to just drop this patch.
>
> Avi?
>
>    

Sure.  If someone complains we can address it then.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

