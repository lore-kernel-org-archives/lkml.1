Return-Path: <linux-kernel-owner+w=401wt.eu-S1754489AbXINH6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489AbXINH6W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 03:58:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752962AbXINH6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 03:58:12 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:42878 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399AbXINH6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 03:58:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=DlfNXKOMEf6Po3A+RbLh7T5F+z8Ol+6suu7b6pFdYQ6xFcMJAXFJ8RQx1uzJbRX0jTcsJKVH02ivasdeLIt5hs3vM93zSbghMdWg7XVXwgjlRBOxnhoeQr0gOr0Y8+Va/u/28pAUdGIFYHHpucXUr5bvxIqj/w41KTmUnmtyTsk=
Message-ID: <46EA3F07.9050806@gmail.com>
Date: Fri, 14 Sep 2007 11:57:59 +0400
From: Manu Abraham <abraham.manu@gmail.com>
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Markus Rechberger <mrechberger@gmail.com>
CC: Steven Toth <stoth@hauppauge.com>,
       "video4linux-list@redhat.com" <video4linux-list@redhat.com>,
       "linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [linux-dvb] [PATCH] Userspace tuner
References: <46C1BCC5.9090709@amd.com>	 <d9def9db0709121546h67d3d1ceuf001ab1d798fde92@mail.gmail.com>	 <d9def9db0709121610n1a78225cs26380b7ca586344a@mail.gmail.com>	 <20070913131353.GB26972@linuxtv.org>	 <d9def9db0709130712h108c7c1obfe24833f5dc27a1@mail.gmail.com>	 <46E95C54.4060502@gmail.com>	 <d9def9db0709130908r6e383c51wd115dd56cfe2beef@mail.gmail.com>	 <46E99F36.8090809@hauppauge.com>	 <d9def9db0709131617l14495fecp5e15f91aa5dd9474@mail.gmail.com>	 <46E9DDC7.4000403@hauppauge.com> <d9def9db0709132338v64ecdcf2ib4e69f1a9c986a5c@mail.gmail.com>
In-Reply-To: <d9def9db0709132338v64ecdcf2ib4e69f1a9c986a5c@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>> What do you think about IOMMU?
>>>
>>>
>> Just because AMD or INTEL want to invent some whizzy new technology it
>> doesn't say anything about the TV card development and retail business.
>> Intel and AMD have teams of Linux engineers helping operating system
>> developers bring their ideas and technologies to new platforms. That's a
>> million miles away from any of the TV board vendors I know of, who have
>> little or NO fulltime linux developers and consider the < 5% market
>> fringe at best.
>>
> 
> it helps to virtualize devices and introduces newer features for that.
> Some interesting projects could be derrived out of that, there are
> quite a few interesting papers floating around how drivers could be
> handled in future.
> 

IOMMU can be considered similar to the AGP GART, which is similar,
remapping the Addresses, as far as i understand.

Though you get a physical to virtual translation, what about interrupts,
yet to be seen with how to do it with multipath scenarios.

Something that i happened to read
https://www.gelato.unsw.edu.au/archives/comp-arch/2007-March/007370.html
Even Documentation/Intel-IOMMU.txt, doesn't seem to paint a very rosy
picture

Manu
