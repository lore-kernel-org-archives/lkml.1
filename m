Return-Path: <linux-kernel-owner+w=401wt.eu-S1030775AbXDQSgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030775AbXDQSgR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 14:36:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030780AbXDQSgR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 14:36:17 -0400
Received: from rtsoft2.corbina.net ([85.21.88.2]:54388 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with SMTP id S1030775AbXDQSgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 14:36:17 -0400
Message-ID: <462513D9.4030403@ru.mvista.com>
Date: Tue, 17 Apr 2007 22:37:13 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: piet@bluelane.com, Tom Rini <trini@kernel.crashing.org>,
       Andi Kleen <ak@suse.de>, Dave Jiang <djiang@mvista.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       George Anzinger <george@wildturkeyranch.net>,
       "David O'Brien" <obrien@FreeBSD.org>
Subject: Re: Permanent Kgdb integration into the kernel - lets get with it.
References: <20070307204516.GA24095@blade.az.mvista.com>	<200703081814.53153.ak@suse.de>	<45F04B6E.9000703@mvista.com>	<200703081937.56167.ak@suse.de>	<20070308184940.GP11626@smtp.west.cox.net>	<1173392650.8912.236.camel@piet2.bluelane.com> <20070417113016.1f0812c7.randy.dunlap@oracle.com>
In-Reply-To: <20070417113016.1f0812c7.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Randy Dunlap wrote:

>>>>>In spite of kgdb, shouldn't it have that \n anyways in case some other code
>>>>>gets added in the future after the macro? Or are you saying that there should
>>>>>never be any code ever after that macro?
>>>>
>>>>Sure if there is mainline code added after that macro we add the \n.
>>>>But only if it makes sense to add code there, which it didn't in kgdb.

>>>Was that because with recent enough tools and config options there was
>>>enough annotations so GDB could finally figure out where things had
>>>stopped?  Thanks.
>>
>>The reason Linus said he didn't allow George's kgdb mm patch to 
>>be integrating into the kernel a year or two ago was that Amit and
>>George had significantly different implementations. So Amit, Tom, 
>>George, and the rest of the kgdb development gang worked together 
>>and came up with a unified version that we now support on SourceForge. 

>>Tom rolled up a mm patch back in December for Andrew and then the
>>integration process stopped. I suggest we work together on getting
>>the kgdb patch back into the mm series and permanently into the kernel
>>like the kexec code and then we can avoid this kernel development
>>obfuscation.
 
> Hi,
> Is there any movement on this?

   Jason Wessel has taken up KGDB maintenance for upstream. We're now working on merging the several diverse trees together.

WBR, Sergei
