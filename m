Return-Path: <linux-kernel-owner+w=401wt.eu-S1753876AbZGXS0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876AbZGXS0v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 14:26:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753717AbZGXS0u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 14:26:50 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:32203 "EHLO
	IE1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753614AbZGXS0u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 14:26:50 -0400
X-SpamScore: -47
X-BigFish: VPS-47(z21eWz1432R9370K98dN936eM9371Pzz1202hzzz2fh6bh61h)
X-Spam-TCS-SCL: 0:0
Message-ID: <4A69FCD3.9070707@am.sony.com>
Date: Fri, 24 Jul 2009 11:26:27 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: naresh kamboju <naresh.kernel@gmail.com>
CC: Mike Frysinger <vapier@gentoo.org>, ltp-list@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, maxin john <maxinbjohn@gmail.com>,
       brinda_mn@yahoo.co.in, Oleg Nesterov <oleg@redhat.com>,
       rohit.170309@gmail.com
Subject: Re: [LTP] Char Limit issue on 2.6.29 kernels
References: <f5a7b3810907240831t75a058a2m96abdc28a28c4365@mail.gmail.com>	 <200907241349.58754.vapier@gentoo.org> <f5a7b3810907241104g498b00a6i60c8858b8805091a@mail.gmail.com>
In-Reply-To: <f5a7b3810907241104g498b00a6i60c8858b8805091a@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-OriginalArrivalTime: 24 Jul 2009 18:26:28.0694 (UTC) FILETIME=[42AB0760:01CA0C8C]
X-SEL-encryption-scan: scanned
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

naresh kamboju wrote:
> Hi Mike,
> 
> On Fri, Jul 24, 2009 at 11:19 PM, Mike Frysinger<vapier@gentoo.org> wrote:
>> On Friday 24 July 2009 11:31:59 naresh kamboju wrote:
>>> I have come across with char Limit issue on 2.6.29 kernels.
>>>
>>>
>>> SIGFAULT:
>>>
>>> #define SIZE � � � � � �8053759
>>> char buf1[SIZE] ;
>>>
>>> NO SIGFAULT:
>>>
>>> #define SIZE � � � � � �8053758
>>> char buf1[SIZE] ;
>>>
>>> This SIGFAULT not observed on 2.6.23 kernels.
>> -ENOINFO
>>
>> post some actual code rather than saying "i declared a large buffer and things
>> crashed".
> 
> currently i am debugging this issue.
> i'll come up with more details.

Some more feedback...

It's SEGFAULT - short for "Segmentation Fault", not SIGFAULT.

Please include in your details at least the following:
 * what software this is in (is this declaration in the kernel?, a library, a
 user space program, etc.)
 * what operation is being performed when the SEGFAULT occurs.
 * what compiler you are using.
 * the code surrounding the operation when the fault occurs

If you can, make the smallest possible program that reproduces this error,
and send the complete source for that.
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

