Return-Path: <linux-kernel-owner+w=401wt.eu-S1758956AbYHAUZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758956AbYHAUZ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 16:25:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752560AbYHAUZW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 16:25:22 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:34575 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbYHAUZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 16:25:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=XVg53s2J1CO4IlbQMcI6ceBPmdw5iIUTDBJFhC3/XIB2Xjveg4pIcOGIt3lGSFQPGH
         LkIb37UT9VK18ap9uP0aEvZGOuN5/0O4X+/pJ3vYTVbNS0DgI3PHF8okrMgTWjak7ta3
         jbXHmBF48qJhq8f4pTaZm3JO07ED9IwB+alqc=
Message-ID: <c4e36d110808011325q612d57dcnfe99e6ef42b1c4ae@mail.gmail.com>
Date: Fri, 1 Aug 2008 22:25:19 +0200
From: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
To: "Alistair John Strachan" <alistair@devzero.co.uk>
Subject: Re: Sysrq+B doesn't work on my box
Cc: "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <c4e36d110808010622w74d61378ud9624a6ea38357a4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c4e36d110807310645n3ff6e61j17414433c5aee030@mail.gmail.com>
	 <48921A0C.7020909@goop.org>
	 <c4e36d110808010254i2274516q4cef62460fe8e8@mail.gmail.com>
	 <200808011356.19027.alistair@devzero.co.uk>
	 <c4e36d110808010622w74d61378ud9624a6ea38357a4@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/8/1 Zdenek Kabelac <zdenek.kabelac@gmail.com>:
> 2008/8/1 Alistair John Strachan <alistair@devzero.co.uk>:
>> On Friday 01 August 2008 10:54:19 Zdenek Kabelac wrote:
>>> 2008/7/31 Jeremy Fitzhardinge <jeremy@goop.org>:
>>> > Zdenek Kabelac wrote:
>>> I'll probably try to bisect  rc.sysinit script to check what is the
>>> first command
>>> that breaks the reboot  - but if there is any idea what should I test
>>> first.?
>>
>> Are you using modules? Maybe a driver is loaded and this upsets the BIOS
>> somehow? If that was the case, the driver wouldn't be loaded in an
>> init=/bin/sh situation, as you described before.
>>
>
>
> Yes - except as I've checked the exactly same modularized kernel
> running Debian on the same box
> has no boot problem.

Ok - idea with checking loaded modules was actually the right way to a
very quick discovery that KVM loaded in my Fedora are the source of
troubles - without them the second mystery is also a history :)

So - is it normal, that loaded KVM modules eliminate emergency reboot
(bug or feature)?

Zdenek
