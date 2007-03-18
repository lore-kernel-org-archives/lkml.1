Return-Path: <linux-kernel-owner+w=401wt.eu-S1753179AbXCRIUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179AbXCRIUs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 04:20:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753184AbXCRIUs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 04:20:48 -0400
Received: from il.qumranet.com ([82.166.9.18]:38961 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753179AbXCRIUr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 04:20:47 -0400
Message-ID: <45FCF65C.2070800@qumranet.com>
Date: Sun, 18 Mar 2007 10:20:44 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Heiko Carstens <heiko.carstens@de.ibm.com>
CC: kvm-devel@lists.sourceforge.net, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [PATCH 08/15] KVM: Add method to check for backwards-compatible
 API extensions
References: <11736212072915-git-send-email-avi@qumranet.com> <1173621207256-git-send-email-avi@qumranet.com> <20070316150622.GC8525@osiris.boeblingen.de.ibm.com>
In-Reply-To: <20070316150622.GC8525@osiris.boeblingen.de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Heiko Carstens wrote:
>> diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
>> index 747966e..376538c 100644
>> --- a/drivers/kvm/kvm_main.c
>> +++ b/drivers/kvm/kvm_main.c
>> @@ -2416,6 +2416,12 @@ static long kvm_dev_ioctl(struct file *filp,
>>  		r = 0;
>>  		break;
>>  	}
>> +	case KVM_CHECK_EXTENSION:
>> +		/*
>> +		 * No extensions defined at present.
>> +		 */
>> +		r = 0;
>> +		break;
>>  	default:
>>     
>
> What exactly is this good for?
>   

Extending the interface in a backwards compatible manner.  When new 
interfaces are added, it will return 1 (depending on arg) for 
implemented extensions.

-- 
error compiling committee.c: too many arguments to function

