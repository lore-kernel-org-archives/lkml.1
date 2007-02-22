Return-Path: <linux-kernel-owner+w=401wt.eu-S1750709AbXBVKSE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750709AbXBVKSE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 05:18:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750719AbXBVKSE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 05:18:04 -0500
Received: from mis011-2.exch011.intermedia.net ([64.78.21.129]:2840 "EHLO
	mis011-2.exch011.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750709AbXBVKSC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 05:18:02 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [kvm-devel] [PATCH 10/13] KVM: Wire up hypercall handlers to a central arch-independent location
Date: Thu, 22 Feb 2007 02:17:54 -0800
Message-ID: <64F9B87B6B770947A9F8391472E032160A91BAF3@ehost011-8.exch011.intermedia.net>
In-Reply-To: <45DD6CF0.3010509@qumranet.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [kvm-devel] [PATCH 10/13] KVM: Wire up hypercall handlers to a central arch-independent location
Thread-Index: AcdWalWqnlQ1qVdXRwOScGs6CW7R0wAACppg
References: <45D979D3.2020907@qumranet.com><20070219103052.4D23725016B@il.qumranet.com><20070221103733.GI3945@ucw.cz> <45DD6CF0.3010509@qumranet.com>
From: "Dor Laor" <dor.laor@qumranet.com>
To: "Avi Kivity" <avi@qumranet.com>, "Pavel Machek" <pavel@ucw.cz>
Cc: <kvm-devel@lists.sourceforge.net>, <akpm@osdl.org>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 22 Feb 2007 10:18:01.0059 (UTC) FILETIME=[BB339330:01C7566A]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>
>Pavel Machek wrote:
>> On Mon 2007-02-19 10:30:52, Avi Kivity wrote:
>>
>>> Signed-off-by: Avi Kivity <avi@qumranet.com>
>>>
>>
>> changelog?
>>
>>
>
>Well, I can't think of anything to add beyond $subject.  The patch adds
>calls from the arch-dependent hypercall handlers to a new arch
>independent function.
>
>
>>> +	switch (nr) {
>>> +	default:
>>> +		;
>>> +	}
>>>
>>
>> Eh?
>>
>>
>
>No hypercalls defined yet.
>

I have Ingo's network PV hypercalls to commit in my piplien.
Till then we can just add the test hypercall:
	case __NR_hypercall_test:
		printk(KERN_DEBUG "%s __NR_hypercall_test\n",
__FUNCTION__);
		ret = 0x5a5a;
		break;
	default:
		BUG();

>
>--
>error compiling committee.c: too many arguments to function
>
>
>-----------------------------------------------------------------------
--
>Take Surveys. Earn Cash. Influence the Future of IT
>Join SourceForge.net's Techsay panel and you'll get the chance to share
>your
>opinions on IT & business topics through brief surveys-and earn cash
>http://www.techsay.com/default.php?page=join.php&p=sourceforge&CID=DEVD
EV
>_______________________________________________
>kvm-devel mailing list
>kvm-devel@lists.sourceforge.net
>https://lists.sourceforge.net/lists/listinfo/kvm-devel
