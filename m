Return-Path: <linux-kernel-owner+w=401wt.eu-S1754557AbZFEMy4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557AbZFEMy4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 08:54:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753065AbZFEMyr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 08:54:47 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43764 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753382AbZFEMyk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 08:54:40 -0400
Message-ID: <4A29154B.2000600@redhat.com>
Date: Fri, 05 Jun 2009 15:53:31 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       Gregory Haskins <gregory.haskins@gmail.com>,
       "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org,
       agraf@suse.de, pmullaney@novell.com, pmorreale@novell.com,
       anthony@codemonkey.ws, netdev@vger.kernel.org, kvm@vger.kernel.org,
       bhutchings@solarflare.com, andi@firstfloor.org, gregkh@suse.de,
       herber@gondor.apana.org.au, chrisw@sous-sol.org, shemminger@vyatta.com
Subject: Re: [RFC PATCH v2 00/19] virtual-bus
References: <20090409155200.32740.19358.stgit@dev.haskins.net> <49E0C93E.5030205@redhat.com> <4A28172D.6010906@gmail.com> <200906051425.02924.rusty@rustcorp.com.au> <4A290800.1030803@novell.com>
In-Reply-To: <4A290800.1030803@novell.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins wrote:
>> @@ -1,6 +1,6 @@
>>  config LGUEST
>>  	tristate "Linux hypervisor example code"
>> -	depends on X86_32 && EXPERIMENTAL && !X86_PAE && FUTEX
>> +	depends on X86_32 && EXPERIMENTAL && !X86_PAE && EVENTFD
>>   
>>     
>
> Note to self:  we probably need a similar line in KVM now.
>
>   

'select EVENTFD' is more appropriate.


-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

