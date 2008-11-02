Return-Path: <linux-kernel-owner+w=401wt.eu-S1753906AbYKBK4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906AbYKBK4U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 05:56:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753382AbYKBK4L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 05:56:11 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:51869 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753378AbYKBK4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 05:56:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=sOBAZU8S9+wI+rjyXo+l/Nm7fJBbbqcgN9eT3/w96oEyhONQzj5HH4Mjhq7dT8x+t5
         U9WKYWd/66IVYtVfePr3xxu9eViPzlRtcDJuD5gZBqg1hixAXyhzD4YRqRFJtR1kSmD4
         D+1MKqVH2/B/xNj+WFjoJpZLjjHr8Fs2HxonI=
Message-ID: <490D873D.9010005@gmail.com>
Date: Sun, 02 Nov 2008 11:55:57 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Helge Deller <deller@gmx.de>
CC: Jiri Kosina <jkosina@suse.cz>, Jeroen Roovers <jer@gentoo.org>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] USBHID: correct start/stop cycle
References: <1225579306-28524-1-git-send-email-jirislaby@gmail.com> <alpine.LNX.1.10.0811020000360.29633@jikos.suse.cz> <490CE128.3020007@gmail.com> <490D8467.5090206@gmx.de>
In-Reply-To: <490D8467.5090206@gmx.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Helge Deller napsal(a):
> Jiri Slaby wrote:
>> On 11/02/2008 12:02 AM, Jiri Kosina wrote:
>>> On Sat, 1 Nov 2008, Jiri Slaby wrote:
>>>
>>>> `stop' left out usbhid->urb* pointers and so the next `start' thought
>>>> it needs to allocate nothing and used the memory pointers previously
>>>> pointed to. This led to memory corruption and device malfunction.
>> [...]
>>> could you please verify whether this patch fixes the corruption you
>>> were experiencing?
>>
>> btw. this is not expected to fix that, but if it does, the better ;).
> 
> I tried the patch and sadly it didn't fixed the parisc bug.

Could you bisect it?
