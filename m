Return-Path: <linux-kernel-owner+w=401wt.eu-S1754543AbZEODCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543AbZEODCV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 23:02:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753596AbZEODCF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 23:02:05 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:43181 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753165AbZEODCE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 23:02:04 -0400
Message-ID: <4A0CDB27.6090009@garzik.org>
Date: Thu, 14 May 2009 23:01:59 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Julian Calaby <julian.calaby@gmail.com>
CC: adam radford <aradford@gmail.com>, "Mukker, Atul" <Atul.Mukker@lsi.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Austria, Winston" <Winston.Austria@lsi.com>,
       "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [RFQ] New driver architecture questions
References: <6C678488C5CEE74F813A4D1948FD2DC7A95E6D37@cosmail02.lsi.com> 	<4A0B858F.3080405@garzik.org> <6C678488C5CEE74F813A4D1948FD2DC7A95E6D38@cosmail02.lsi.com> 	<4A0B9B0D.6080006@garzik.org> <b1bc6a000905141758y20aa7852h8b1012e3da6f8c0f@mail.gmail.com> <646765f40905141801k5ae6249p925a4a377652c62e@mail.gmail.com>
In-Reply-To: <646765f40905141801k5ae6249p925a4a377652c62e@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julian Calaby wrote:
> On Fri, May 15, 2009 at 10:58, adam radford <aradford@gmail.com> wrote:
>> On Wed, May 13, 2009 at 9:16 PM, Jeff Garzik <jeff@garzik.org> wrote:
>>> Taking drivers/net/e1000e as an
>>> example,
>>>
>>>        hw.h            hardware-specific defines, ~cross-OS
>>>        82571.c         code specific to 8257x chip family, ~cross-OS
>> 82571.c contains Linux specific code such as:  including Linux
>> specific header files, calls to msleep().
>>
>>>        ich8lan.c       code specific to ICH8+ chip family, ~cross-OS
>> ich8lan.c contains Linux specific code such as:  might_sleep(),
>> mutex_trylock(), mutex_unlock(), udelay(), msleep(), writel(), readl().
>>
>> Perhaps this is a bad example?  It seems like the "common layer"
>> sections that are "cross-OS" shouldn't contain any Linux specific code at all.
> 
> I think the implication is that the cross-OS parts are coded, as it
> happens, in the linux coding style, using linux functions, but then a
> Windows layer maps these to Windows specific functions.

Correct.

	Jeff




