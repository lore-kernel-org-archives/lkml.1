Return-Path: <linux-kernel-owner+w=401wt.eu-S1758091AbZDKMYz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758091AbZDKMYz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 08:24:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754159AbZDKMYp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 08:24:45 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54715 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752899AbZDKMYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 08:24:44 -0400
Message-ID: <49E08C2F.4010003@redhat.com>
Date: Sat, 11 Apr 2009 15:25:19 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Huang Ying <ying.huang@intel.com>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add MCE support to KVM
References: <1239155601.6384.3.camel@yhuang-dev.sh.intel.com> <49DE195D.1020303@redhat.com> <1239332455.6384.108.camel@yhuang-dev.sh.intel.com> <49E08762.1010206@redhat.com> <20090411121911.GR14687@one.firstfloor.org>
In-Reply-To: <20090411121911.GR14687@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> Right, but we can allocate the maximum number, no?  it's a fairly small 
>> amount of memory.
>>     
>
> There are 255 banks worst case which need upto 4 (in theory 5) MSRs each
>
>   

That's 8KB, which would normally not be allocated.  But I think we can 
live with it.

Do we actually need to support 255 banks?  Or can we support a smaller 
number transparently?

(IOW: are the banks interchangable?)

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

