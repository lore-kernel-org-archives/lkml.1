Return-Path: <linux-kernel-owner+w=401wt.eu-S1755997AbYIIMtG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997AbYIIMtG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 08:49:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751606AbYIIMsz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 08:48:55 -0400
Received: from ag-out-0708.google.com ([72.14.246.248]:57382 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbYIIMsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 08:48:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=cycxlkpHYACn1Vafh/UmhKW/ocHtUSRn71Fxmx0m0XOOTJl/S+4NWAdcvIvWEu5MDd
         eyxPU6e8QME6lyKyHwp+idWM3WS6FPi0pqal2JzBDIr/bbbzbTarRmddmX6odSRc3saD
         RzRI6fS1+cLbfgQLHHqy/cJPaBM6iySu4wp84=
Date: Tue, 9 Sep 2008 20:28:46 +0800
From: Yan Li <elliot.li.tech@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yan Li <elliot.li.tech@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, joerg.roedel@amd.com, rjmaomao@gmail.com,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, nancydreaming@gmail.com
Subject: Re: [PATCH 1/2] VMware detection support for x86 and x86-64
Message-ID: <20080909122846.GA25467@yantp.cn.ibm.com>
References: <20080221115452.GB13948@elte.hu> <20080907234510.GA24133@yantp.cn.ibm.com> <20080908140423.GG11993@elte.hu> <20080909002055.GA8573@yantp.cn.ibm.com> <48C5C47F.5040004@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48C5C47F.5040004@zytor.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2008 at 05:34:07PM -0700, H. Peter Anvin wrote:
>> VMware may change the PCI ID at their will so I prefer checking the
>> DMI since it's easier.
>>
>> So if we ditched the official method we run the risk of some false
>> negatives.  But checking the DMI manufacturer would be good enough.
>>
>
> If we get false negatives that is quite frankly their problem, not ours.  
>  If nothing else, we should be able to look for a host bridge with the  
> VMWare vendor ID -- that should arguably be safer than DMI.

Yeah, VMware's PCI vendor Id: 0x15AD

Why using PCI vendor ID is safer than DMI?

-- 
Li, Yan

"Everything that is really great and inspiring is created by the
individual who can labor in freedom."
              - Albert Einstein, in Out of My Later Years (1950)
