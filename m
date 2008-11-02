Return-Path: <linux-kernel-owner+w=401wt.eu-S1753899AbYKBKoI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899AbYKBKoI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 05:44:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753379AbYKBKnz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 05:43:55 -0500
Received: from mail.gmx.net ([213.165.64.20]:58002 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753369AbYKBKny (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 05:43:54 -0500
X-Authenticated: #1045983
X-Provags-ID: V01U2FsdGVkX18Z7Sx8smgZYZ6EBN/pSbfhrjcSMqlWTJBQHhoRd5
	hdB2QC1lPPE77+
Message-ID: <490D8467.5090206@gmx.de>
Date: Sun, 02 Nov 2008 11:43:51 +0100
From: Helge Deller <deller@gmx.de>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: Jiri Kosina <jkosina@suse.cz>, Jeroen Roovers <jer@gentoo.org>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] USBHID: correct start/stop cycle
References: <1225579306-28524-1-git-send-email-jirislaby@gmail.com> <alpine.LNX.1.10.0811020000360.29633@jikos.suse.cz> <490CE128.3020007@gmail.com>
In-Reply-To: <490CE128.3020007@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby wrote:
> On 11/02/2008 12:02 AM, Jiri Kosina wrote:
>> On Sat, 1 Nov 2008, Jiri Slaby wrote:
>>
>>> `stop' left out usbhid->urb* pointers and so the next `start' thought
>>> it needs to allocate nothing and used the memory pointers previously
>>> pointed to. This led to memory corruption and device malfunction.
> [...]
>> could you please verify whether this patch fixes the corruption you were 
>> experiencing?
> 
> btw. this is not expected to fix that, but if it does, the better ;).

I tried the patch and sadly it didn't fixed the parisc bug.

Helge

> This fixes
> echo DEVICE > /sys/bus/hid/drivers/DRIVER/unbind
> echo DEVICE > /sys/bus/hid/drivers/DRIVER/bind
> failures.
> 
> But maybe parisc does something differently than x86 in bus handling so that it
> triggers...
