Return-Path: <linux-kernel-owner+w=401wt.eu-S1753281AbYIYFEm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281AbYIYFEm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 01:04:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751920AbYIYFEe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 01:04:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40183 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686AbYIYFEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 01:04:34 -0400
Message-ID: <48DB1BCE.2070106@zytor.com>
Date: Wed, 24 Sep 2008 22:04:14 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: akataria@vmware.com
CC: Alok kataria <alokkataria1@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Yan Li <elliot.li.tech@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "joerg.roedel@amd.com" <joerg.roedel@amd.com>,
       "rjmaomao@gmail.com" <rjmaomao@gmail.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Daniel Hecht <dhecht@vmware.com>,
       Zach Amsden <zach@vmware.com>
Subject: Re: [PATCH 1/2] VMware detection support for x86 and x86-64
References: <20080221115452.GB13948@elte.hu>	 <20080907234510.GA24133@yantp.cn.ibm.com>	 <20080908140423.GG11993@elte.hu>	 <35f686220809241928k3669e30bi8a98b440443c4bff@mail.gmail.com>	 <48DB15DB.8040501@zytor.com> <1222317978.23524.117.camel@alok-dev1>	 <48DB1984.8020704@zytor.com> <1222318928.23524.121.camel@alok-dev1>
In-Reply-To: <1222318928.23524.121.camel@alok-dev1>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alok Kataria wrote:
>>>
>> You accessed a bloody I/O port!
>>
>> If you think it's harmless because it was an IN, you're sorely mistaken.
> 
> Hi Peter, 
> 
> It would be really helpful if you could explain me when can this go
> wrong or what kinds of problems can this cause on native hardware.
> 

You accessed an unknown I/O port.

This means you caused an unknown action in an unknown peripheral device.

This could cause ANYTHING to happen.

	-hpa

