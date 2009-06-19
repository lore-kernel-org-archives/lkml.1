Return-Path: <linux-kernel-owner+w=401wt.eu-S1757681AbZFSVCW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757681AbZFSVCW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 17:02:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752709AbZFSVCO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 17:02:14 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:63632 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908AbZFSVCO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 17:02:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=aqeG+6zk6E76Yg8qIVVVeamE8D5nEyovZaatwNN/S+6LV/nOpHnAKYfD++zRDyeadH
         uUQmL9BYoOOsKWbvy6Q4Iatr0/Ak46WcbhjETCZfG+B9v/P+IgXVzfr7R1jSsHpJISJr
         pwPki6P7hGcwER7+xns+ueIesiEL3LZ6QgLV8=
MIME-Version: 1.0
In-Reply-To: <4A3BF2FA.2010708@msgid.tls.msk.ru>
References: <1245439404.25076.7.camel@ronispc.chem.mcgill.ca>
	 <4A3BE7EA.4050800@msgid.tls.msk.ru>
	 <dd18b0c30906191255h7d0c6bcfx58f32d4b34e13c34@mail.gmail.com>
	 <4A3BF2FA.2010708@msgid.tls.msk.ru>
Date: Fri, 19 Jun 2009 13:55:02 -0700
Message-ID: <dd18b0c30906191355v616b924ct98874bf015c5ac66@mail.gmail.com>
Subject: Re: Panic booting 2.6.30
From: Justin Mattock <justinmattock@gmail.com>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: ronis@ronispc.chem.mcgill.ca, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 19, 2009 at 1:20 PM, Michael Tokarev<mjt@tls.msk.ru> wrote:
> Justin Mattock wrote:
>>
>> On Fri, Jun 19, 2009 at 12:32 PM, Michael Tokarev<mjt@tls.msk.ru> wrote:
>>>
>>> David Ronis wrote:
>>>>
>>>> I've just upgraded an older machine (a P3 running slackware 11.0) from
>>>> 2.6.26.5 to 2.6.30; the build was uneventful.  However, on reboot (using
>>>> lilo) I get:
>>>>
>>>> VSF:  Cannot open root device "hda2" or unknown-block(0,0)
>>>> Please append a correct root= boot option; here are the available
>>>> partions:     <====== nothing shows here...
>>>> Kernel-Panic - not syncing.
>>>>
>>>> I had rebooted with and without root=hda2.   The old kernel is still
>>>> usable.
>>>>
>>>> Lilo.conf looks like:
>>>
>>> Add large-memory option to lilo.conf
>>
>> check  /dev/hda*  to see
>> if it renamed itself to /dev/sda*
>
> It cant "rename itself".
>
> The difference between sd* and hd* is different driver for the
> controller - either old good ide code (like piix) - that's hd*,
> or libata-based code (ata_piix).  Which one is compiled into
> your kernel or gets loaded by initrd is controlled by you, not
> by kernel or drivers.
>
> /mjt
>

ahh.. that's what I did then
had old, then changed to new,
but didn't realize.
Thanks for clearing that up.

-- 
Justin P. Mattock
