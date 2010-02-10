Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752443Ab0BJTUc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 14:20:32 -0500
Received: from borg.medozas.de ([188.40.89.202]:47179 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751965Ab0BJTUb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 14:20:31 -0500
Date: Wed, 10 Feb 2010 20:20:26 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Jeremy Fitzhardinge <jeremy@xensource.com>, virtualization@lists.osdl.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Paravirt compile failure with gcc33
In-Reply-To: <4B72FD09.1020202@goop.org>
Message-ID: <alpine.LSU.2.01.1002102019430.6708@obet.zrqbmnf.qr>
References: <alpine.LSU.2.01.1002101909560.29808@obet.zrqbmnf.qr> <4B72FD09.1020202@goop.org>
User-Agent: Alpine 2.01 (LSU 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 2010-02-10 19:38, Jeremy Fitzhardinge wrote:

> On 02/10/2010 10:13 AM, Jan Engelhardt wrote:
>> As I was compile-testing 2.6.33-rc with gcc-3.3,
>> binutils-2.19.51-10.26.4.x86_64, I observed a failure when
>> CONFIG_PARAVIRT is turned on:
>>   
>
> Yeah, there's a gcc bug of some kind there, and its very hard to see how to
> work around it.  When we last discussed this, I think we were close to deciding
> to obsolete gcc 3.3.
>
> HPA, do you remember?

In fact, there's such a big bug in there that I'll get a runaway 
allocation later on when kvm.o is to be compiled. This is getting fun,
but I am absolutely fine with obsoleting 3.x  :)
