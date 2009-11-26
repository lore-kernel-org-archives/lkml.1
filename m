Return-Path: <linux-kernel-owner+w=401wt.eu-S1760822AbZKZQpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760822AbZKZQpZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 11:45:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759229AbZKZQpY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 11:45:24 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:37103 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759219AbZKZQpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 11:45:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=HZy80sfEqAd9kClWGGT8QGi1wdujXGPQ36rI1eFXWbQHj7fMEpm2dMsaEZggfn2sSV
         ToVvzkk6r5ibK+iUdOa0HMrOCO9682xueyjbE4JXQJaBO83kS10YvYM3FXwWC1GVK5lF
         jAu+mKzb6nT3OT5yCkOSSlDsyguXViqGmjls4=
Message-ID: <4B0EB0A1.90403@gmail.com>
Date: Thu, 26 Nov 2009 18:45:21 +0200
From: =?windows-1252?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20091109)
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Mauro Carvalho Chehab <mchehab@redhat.com>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: Memset of length zero bugs
References: <20091111215703.GA24390@redhat.com> <4B0E6189.6050708@gmail.com>
In-Reply-To: <4B0E6189.6050708@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2009-11-26 13:07, Török Edwin wrote:
> On 2009-11-11 23:57, Dave Jones wrote:
>   
>> Nearly every invocation of memset in drivers/staging/hv/StorVsc.c
>> has it's arguments the wrong way around.
>>     
> Hi,
>
> I found 2 more bugs like this in v2.6.32-rc8-11-ga8a8a66 by letting gcc
> warn in such cases on an allyesconfig build.
> I used the attached patch (meant to be used only to find bugs, linking
> fails).
>   

Forgot to mention that this code is the one from glibc (2.10.1)'s memset.

Best regards,
--Edwin
