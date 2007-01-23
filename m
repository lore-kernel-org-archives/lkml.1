Return-Path: <linux-kernel-owner+w=401wt.eu-S964919AbXAWM5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964919AbXAWM5a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 07:57:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964872AbXAWM5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 07:57:30 -0500
Received: from main.gmane.org ([80.91.229.2]:54563 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964919AbXAWM53 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 07:57:29 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Rolf Offermanns <roffermanns@gmail.com>
Subject: Re: How to use an usb interface than is claimed by HID?
Date: Tue, 23 Jan 2007 13:57:11 +0100
Message-ID: <ep50n7$dni$1@sea.gmane.org>
References: <45B265E0.5020605@gmail.com> <Pine.LNX.4.64.0701211358570.21127@twin.jikos.cz> <Pine.LNX.4.64.0701211821530.21127@twin.jikos.cz> <200701212134.58646.uvsoft@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: 62.8.134.2
User-Agent: KNode/0.10.4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ivan Ukhov wrote:

>> .. which wouldn't help you either, supposing that you don't want to touch
>> the kernel sources at all, because this function is unexported and
>> static.
>>
>> So I think that there is no straightforward way, sorry.
>>
>> Is this a device that doesn't exist anywhere else than on your table? I
>> still think that putting the code in kernel (if possible) and
>> blacklisting the device on the hid_blacklist[] is the simplest way.
>>
>> The other possibility is writing the driver completely in userspace,
>> using libhid/hiddev. Would that suit your needs?
> 
> I'm afraid it wouldn't.
> 
> Thank you very much.
> 
There is another way. Have a look at this article:
http://lwn.net/Articles/143397/

Maybe this is an option for you.

-Rolf
-- 
Rolf Offermanns <roffermanns@sysgo.com>
SYSGO AG     Tel.: +49-6136-9948-0
Am Pfaffenstein 14   Fax: +49-6136-9948-10
55270 Klein-Winternheim  http://www.sysgo.com

