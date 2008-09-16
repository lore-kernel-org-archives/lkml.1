Return-Path: <linux-kernel-owner+w=401wt.eu-S1756676AbYIPSPV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756676AbYIPSPV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 14:15:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753473AbYIPSPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 14:15:09 -0400
Received: from hobbit.corpit.ru ([81.13.33.150]:23795 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752842AbYIPSPI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 14:15:08 -0400
Message-ID: <48CFF7A9.3070007@msgid.tls.msk.ru>
Date: Tue, 16 Sep 2008 22:15:05 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: PARAVIRT_GUEST bug? [was: Stable regression: usb-storage is stuck
 in 2.6.26.5]
References: <20080913122143.4B13B908E@gandalf.tls.msk.ru> <48CBB626.4050300@msgid.tls.msk.ru> <48CF6A45.3010204@msgid.tls.msk.ru> <48CFEA8C.3020703@goop.org>
In-Reply-To: <48CFEA8C.3020703@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
[...]
> Michael Tokarev wrote:
>> The question is if Asus introduced the same bug in quite.. some
>> of their recent BIOSes, or PARAVIRT_GUEST code is somehow buggy
>> and the bug is exposed by new BIOS code.
>>
>> Any hints on this? ;)
> 
> PARAVIRT_GUEST doesn't enable anything by itself; it just makes other
> config options appear.  What other config options are you enabling?
> 
> That is, what's the diff between a working and a non-working .config?

I stand corrected.  I meant to say CONFIG_PARAVIRT, not CONFIG_PARAVIRT_GUEST:

# diff -U0 config.working config.bad
--- config.working	2008-09-16 22:09:14.844324435 +0400
+++ .config.bad	2008-09-16 22:10:04.914320258 +0400
@@ -4 +4 @@
-# Tue Sep 16 21:47:31 2008
+# Tue Sep 16 22:10:04 2008
@@ -181 +181 @@
-# CONFIG_PARAVIRT is not set
+CONFIG_PARAVIRT=y

/mjt
