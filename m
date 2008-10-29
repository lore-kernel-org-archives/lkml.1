Return-Path: <linux-kernel-owner+w=401wt.eu-S1753737AbYJ2Cic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737AbYJ2Cic (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 22:38:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752335AbYJ2CiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 22:38:23 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:50261 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312AbYJ2CiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 22:38:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=IdR53Zxy/EU8ITjpAxDoEoqBe6eHxPz9r9RneTAOlre6QBw+wP5NMRIJ2nY+VjgHHX
         slf0lzGz7zF+gNGmPqm2kKZTlDriNmy2AxMBI0iPnQU6NozpPVp787UnBdZwgvGArlgK
         EDDWy2TXA3n1J6ByFGf8d0xe+n0Os5MWhUE+U=
Message-ID: <e8ca35370810281938y38daaa5fo581817264a8959db@mail.gmail.com>
Date: Wed, 29 Oct 2008 03:38:20 +0100
From: "Pascal Terjan" <pterjan@mandriva.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: pm_op(): pci_pm_restore+0x0/0x70 returns -16
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <200810290018.24479.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1225190519.8039.14.camel@plop> <200810290018.24479.rjw@sisk.pl>
X-Google-Sender-Auth: b35e536d0aa4ea76
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2008 at 12:18 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Tuesday, 28 of October 2008, Pascal Terjan wrote:
>> Since I updated my laptop (Thikpad T40) to 2.6.27-rc5 and all new
>> kernels until 2.6.27.3 (was using 2.6.25 before), I get this at resume
>> time after hibernation :
>>
>> Oct 28 10:39:18 plop kernel: pm_op(): pci_pm_restore+0x0/0x70 returns
>> -16
>> Oct 28 10:39:19 plop kernel: PM: Device 0000:00:00.0 failed to restore:
>> error -16
>>
>> This may or may not be related to resume issues I often get.
>>
>> Sometimes it still work fine, sometimes it panics but I can't get any
>> log, sometimes I get back to X but without USB mouse, without keyboard
>> and ssh not responding (sysrq still work).
>
> It looks like the ->restore() callback fails for your hostbridge.  It might
> have done that before, but we've only been reporting such failures since the
> 2.6.27 development cycle.
>
> Did hibernation work correctly with 2.6.25?

Yes it worked fine
I hibernate twice a day and never got failures with old kernels while
it now fails to resume most of the time, but other things have changed
and I did not do any investigation (for example I switched to libata
while switching to 2.6.27-rc).
If this message is only additional reporting, i will try to do some more testing
