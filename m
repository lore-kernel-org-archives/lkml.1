Return-Path: <linux-kernel-owner+w=401wt.eu-S1756687AbYFGXUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687AbYFGXUW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 19:20:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753695AbYFGXUK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 19:20:10 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:61415 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084AbYFGXUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 19:20:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=mYMJDdfceQ2sL2EpMqx49f7/qtDWAJs2Imk5OmOxWStNAm5ctkMH8Ag5qQWx53yigl
         ZWGxGR78iScwj0LVXZHwJ0v3JZcNLJB2kiMHTlHNltomOmphaIBkxmu98aMDDE0OLCrZ
         RJjeuip161XrFRA32qIyyFHyKSmcFdajDrAJU=
Message-ID: <dd18b0c30806071620o7b1c591dmf86081eadaa8078c@mail.gmail.com>
Date: Sat, 7 Jun 2008 23:20:07 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Alexey Starikovskiy" <astarikovskiy@suse.de>
Subject: Re: ACPI: EC: GPE storm detected, disabling EC GPE
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
In-Reply-To: <484AFD3C.7080600@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dd18b0c30806062321x2918f6feq7c817bde52ba0c4c@mail.gmail.com>
	 <20080606235526.783acc83.akpm@linux-foundation.org>
	 <dd18b0c30806070847t63b8dbc0x8bfcbafc359f7031@mail.gmail.com>
	 <484AE148.6000204@suse.de>
	 <dd18b0c30806071335j200daa9t517bf41ab10b2f@mail.gmail.com>
	 <484AFD3C.7080600@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 7, 2008 at 9:27 PM, Alexey Starikovskiy
<astarikovskiy@suse.de> wrote:
> Justin Mattock wrote:
>>
>> Interesting, over here I'm using a Macbook Pro ATI chipset. I'm not
>> experiencing things like missing keys or anything of that nature.
>> but am concerned with what might happen to the hardware in the long
>> run. As for the patches I did apply those,
>> and it did give me a better idea of what is happening., but just to
>> get a right info, when ACPI: EC: gpe storm detected message appears
>> does it disable interrupt mode for that moment and then go back to it
>> original state, or is it once the gpe storm is triggered the interupt
>> mode is disabled until a reboot is performed. from looking at the data
>> from the patches that I used from here it looks like something in the
>> system triggers that message, but then after a few seconds  goes back
>> to its original state, until another storm is detected.
>> I don't have a problem with this message if it's triggering and then
>> returning to it's original state until another storm triggers this
>> message again, but I am concerned with the message being triggered,
>> and then the system is stuck in that mode until a reboot.(but if this
>> is O.K. for the system then that's cool too).
>
> If interrupt storm from EC is detected EC interrupt will be disabled
> permanently.
> EC driver then starts to poll hardware for events in half-second interval,
> so it is
> still fully functional, but may be there is going to be impact on power
> consumption, etc.
>
> Regards,
> Alex.
>

Hmmm, power consumption., well that's not bad, but maybe I should be
concerned with my battery, maybe I should
remove my battery, and use it only if I need be., just to be on the
safe side. (apple already replaced this one for free, without apple
care, so
I don't think they want to do that again.)
regards;

-- 
Justin P. Mattock
