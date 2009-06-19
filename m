Return-Path: <linux-kernel-owner+w=401wt.eu-S1752683AbZFSTz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683AbZFSTz2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 15:55:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750777AbZFSTzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 15:55:20 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:51416 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbZFSTzT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 15:55:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=awTGSW256I4ZX/4maA9WxAF2cqR5XINB4Sw5jWnGzyWXFnabeFkMSoexbFKQaE2ZF4
         ZmlE9VPrcKhlK1kRKYIkhgrmryyzoRWYG5iXiZlx9QL4orM2z27xmRqV+seWh9luIbWx
         Lc9piZ8kuUFKS0yFLBPRun08QZOkkG9QHIEDE=
MIME-Version: 1.0
In-Reply-To: <4A3BE7EA.4050800@msgid.tls.msk.ru>
References: <1245439404.25076.7.camel@ronispc.chem.mcgill.ca>
	 <4A3BE7EA.4050800@msgid.tls.msk.ru>
Date: Fri, 19 Jun 2009 12:55:20 -0700
Message-ID: <dd18b0c30906191255h7d0c6bcfx58f32d4b34e13c34@mail.gmail.com>
Subject: Re: Panic booting 2.6.30
From: Justin Mattock <justinmattock@gmail.com>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: ronis@ronispc.chem.mcgill.ca, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 19, 2009 at 12:32 PM, Michael Tokarev<mjt@tls.msk.ru> wrote:
> David Ronis wrote:
>>
>> I've just upgraded an older machine (a P3 running slackware 11.0) from
>> 2.6.26.5 to 2.6.30; the build was uneventful.  However, on reboot (using
>> lilo) I get:
>>
>> VSF:  Cannot open root device "hda2" or unknown-block(0,0)
>> Please append a correct root= boot option; here are the available
>> partions:     <====== nothing shows here...
>> Kernel-Panic - not syncing.
>>
>> I had rebooted with and without root=hda2.   The old kernel is still
>> usable.
>>
>> Lilo.conf looks like:
>
> Add large-memory option to lilo.conf
>
> /mjt
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

check  /dev/hda*  to see
if it renamed itself to /dev/sda*
(noticed this a few months ago with
2.6.17(I think) to 2.6.24)

-- 
Justin P. Mattock
