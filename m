Return-Path: <linux-kernel-owner+w=401wt.eu-S1758739AbXLLARm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758739AbXLLARm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 19:17:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755538AbXLLARd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 19:17:33 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:55668 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125AbXLLARc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 19:17:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:from;
        b=YzSVMEM5ktqQSrlLeCJnKipu47dmK+w5KuLIArq+csfEfcy2AjfaR6CXyZcKd1AUlDdECir2Sdc06xfKh5xbe0evox/JOnT3/8/C3KKf1n12GYAJK4ziBvoZcPaABKa2hyo2sjrahKUx0mGsIQuoqggFL6bAsmJvqjl3w3aOLyY=
Message-ID: <475F2846.1010402@keyaccess.nl>
Date: Wed, 12 Dec 2007 01:16:06 +0100
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: =?ISO-8859-15?Q?Alejandro_Riveira_Fern=E1ndez?= 
	<ariveira@gmail.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, dpreed@reed.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, pavel@ucw.cz, andi@firstfloor.org,
       rol@as2917.net, Krzysztof Halasa <khc@pm.waw.pl>, david@davidnewall.com,
       hpa@zytor.com, john@stoffel.org, linux-os@analogic.com
Subject: Re: [RFT] Port 0x80 I/O speed
References: <475F1DC6.5090403@keyaccess.nl>	<20071212004316.079e3a05@Varda>	<475F227D.7050203@keyaccess.nl> <20071212010928.3c763ccd@Varda>
In-Reply-To: <20071212010928.3c763ccd@Varda>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
From: Rene Herman <rene.herman@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-12-07 01:09, Alejandro Riveira Fernández wrote:

>>>  On my AMD 3800 X2 (2000MHz) ULi M1697 2.6.24-rc5 i get:
>>>
>>>  cycles: out 1844674407370808, in 1844674407369087
>>>  
>>> It is not constant but variations are not significant afaics
>> Eh, oh, I guess you need to compile as a 32-bit binary...
>  
>  I tried without -O2 as Nigel Cunningham...
> 
>  cycles: out 1562, in 865
>  cycles: out 1562, in 866
>  cycles: out 1555, in 858
>  cycles: out 1562, in 866
>  
>  With -m32 -O2
>  cycles: out 1566, in 876
>  cycles: out 1555, in 865
>  cycles: out 1594, in 931
>  cycles: out 1559, in 874

Great, thanks much for reporting. Sort of interesting in itself that without 
-O2 you do still get correct results on 64-bit but for some other time.

You're the first one to go significantly below 1 us it seems.

Rene.
