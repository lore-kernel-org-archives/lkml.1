Return-Path: <linux-kernel-owner+w=401wt.eu-S1755945AbYIIAee@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945AbYIIAee (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 20:34:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754751AbYIIAe0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 20:34:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51910 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754738AbYIIAe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 20:34:26 -0400
Message-ID: <48C5C47F.5040004@zytor.com>
Date: Mon, 08 Sep 2008 17:34:07 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Yan Li <elliot.li.tech@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       joerg.roedel@amd.com, rjmaomao@gmail.com,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, nancydreaming@gmail.com
Subject: Re: [PATCH 1/2] VMware detection support for x86 and x86-64
References: <20080221115452.GB13948@elte.hu> <20080907234510.GA24133@yantp.cn.ibm.com> <20080908140423.GG11993@elte.hu> <20080909002055.GA8573@yantp.cn.ibm.com>
In-Reply-To: <20080909002055.GA8573@yantp.cn.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yan Li wrote:
> 
> VMware may change the PCI ID at their will so I prefer checking the
> DMI since it's easier.
> 
> So if we ditched the official method we run the risk of some false
> negatives.  But checking the DMI manufacturer would be good enough.
> 

If we get false negatives that is quite frankly their problem, not ours. 
  If nothing else, we should be able to look for a host bridge with the 
VMWare vendor ID -- that should arguably be safer than DMI.

	-hpa
