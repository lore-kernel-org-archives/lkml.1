Return-Path: <linux-kernel-owner+w=401wt.eu-S1753124Ab0AUJH4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124Ab0AUJH4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 04:07:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752015Ab0AUJHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 04:07:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63036 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751953Ab0AUJHx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 04:07:53 -0500
Message-ID: <4B5818EA.10709@redhat.com>
Date: Thu, 21 Jan 2010 11:05:46 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
       kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@linutronix.de, riel@redhat.com,
       cl@linux-foundation.org
Subject: Re: [PATCH v3 04/12] Add "handle page fault" PV helper.
References: <4B541D08.9040802@zytor.com> <20100118085022.GA30698@redhat.com> <4B5510B1.9010202@zytor.com> <20100119065537.GF14345@redhat.com> <4B55E5D8.1070402@zytor.com> <20100119174438.GA19450@redhat.com> <4B5611A9.4050301@zytor.com> <20100120100254.GC5238@redhat.com> <4B5740CD.4020005@zytor.com> <4B58181B.60405@redhat.com> <20100121090421.GS5238@redhat.com>
In-Reply-To: <20100121090421.GS5238@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2010 11:04 AM, Gleb Natapov wrote:
>
>> Do you mean create the stack frame manually?  I'd really like to
>> avoid that for many reasons, one of which is performance (need to do
>> all the virt-to-phys walks manually), the other is that we're
>> certain to end up with something horribly underspecified.  I'd
>> really like to keep as close as possible to the hardware.  For the
>> alternative approach, see Xen.
>>
>>      
> That and our event injection path can't play with guest memory right now
> since it is done from atomic context.
>    

That's true (I'd like to fix that though, for the real mode stuff).

-- 
error compiling committee.c: too many arguments to function

