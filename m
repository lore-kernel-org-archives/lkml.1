Return-Path: <linux-kernel-owner+w=401wt.eu-S1757669AbZDNSKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757669AbZDNSKd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 14:10:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755729AbZDNSKH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 14:10:07 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:65268 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757527AbZDNSKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 14:10:05 -0400
Message-ID: <49E4D17E.8020602@vlnb.net>
Date: Tue, 14 Apr 2009 22:10:06 +0400
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Tomasz Chmielewski <mangoo@wpkg.org>
CC: Bart Van Assche <bart.vanassche@gmail.com>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       scst-devel <scst-devel@lists.sourceforge.net>, stgt@vger.kernel.org
Subject: Re: [Scst-devel] [ANNOUNCE]: Comparison of features sets between
 	different SCSI targets (SCST, STGT, IET, LIO)
References: <49D7AD54.4060408@vlnb.net> <49D7B122.50103@wpkg.org> <e2e108260904050429lcd1870ag6656f36a170ccab3@mail.gmail.com> <49D9D9A0.40106@wpkg.org> <49DA33EF.3020700@vlnb.net> <49DA49AA.1060106@wpkg.org> <49DE4243.5060004@vlnb.net> <49E46E73.8020703@wpkg.org>
In-Reply-To: <49E46E73.8020703@wpkg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX18rPrlNHiPQaRJ/dbLKESxh43++9ovA4gv8nVN
 xedbX4ELtN4xWy8aWjx/Nbhh5NL6ibgklaiDMVEYJNKDUdo6c2
 xpLK23CS2bDNBfwKqWZiw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Tomasz Chmielewski, on 04/14/2009 03:07 PM wrote:
> Vladislav Bolkhovitin schrieb:
> 
>>> Could anyone recheck if it's the same on some other system?
>>>
>>>> Which IO scheduler on the target did you use? I guess, deadline? If 
>>>> so, you should try with CFQ as well.
>>> I used CFQ.
>> You didn't apply io_context-XXX.patch, correct? With it you should see a 
>>  noticeable increase, like in http://scst.sourceforge.net/vl_res.txt.
> 
> I didn't apply this one.
> 
> I used 2.6.26.x kernel and io_context-XXX.patch was for 2.6.27, 2.6.28 
> and 2.6.29 only; 2.6.27 fails to apply to 2.6.26.8 kernel (perhaps in a 
> trivial way, I didn't check).

Yes, io_context patch for 2.6.26.x kernels doesn't exist, because it 
isn't clear if it has the necessary functionality.

But it's worth for you to upgrade to 2.6.27.x. Have you seen 
http://scst.sourceforge.net/vl_res.txt?

Vlad
