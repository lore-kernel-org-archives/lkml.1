Return-Path: <linux-kernel-owner+w=401wt.eu-S1757933AbXITSeP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757933AbXITSeP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 14:34:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756766AbXITSeA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 14:34:00 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:23333 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753311AbXITSd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 14:33:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Ha5WOTooozWX6zDihE4T9VpwjyLXNIbNkG8kRTQG2O4xwffePXmOvo614AjDSKO2+NRp1MIDICkCUPsd5SAwxMUbXF2PA+63IgWIqOpliqC+ZTGQDeajWP0KVc7VsJ+uLjyYGFrFbfpdmOqr1Tqc3T/xiKsXPbK/bNf5HXP3FAg=
Message-ID: <46F2BD0D.2010206@gmail.com>
Date: Thu, 20 Sep 2007 22:33:49 +0400
From: Alexey Starikovskiy <aystarik@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Frans Pop <elendil@planet.nl>
CC: Pavel Machek <pavel@ucw.cz>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Maciek Rutecki <maciej.rutecki@gmail.com>
Subject: Re: 2.6.23-rc6: S4 and S5 no longer listed as supported on Toshiba
 Satellite A40
References: <200709192014.08443.elendil@planet.nl> <46F2A0E9.9000603@gmail.com> <46F2AE16.9080803@gmail.com> <200709202017.50934.elendil@planet.nl>
In-Reply-To: <200709202017.50934.elendil@planet.nl>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Frans Pop wrote:
> On Thursday 20 September 2007, you wrote:
>> Please try this patch.
> 
> Works. All states are now listed again.
> I've not tested suspend to disk, but suspend to ram and power off work fine.
> 
>> +printk(KERN_INFO PREFIX "(supports");
>>  #ifdef CONFIG_SUSPEND
>> -       printk(KERN_INFO PREFIX "(supports");
>>         for (i = ACPI_STATE_S0; i < ACPI_STATE_S4; i++) {
> 
> Isn't there a risk now that we now end up printing
>    ACPI: (supports)
> if CONFIG_SUSPEND is not enabled and >S4 is not supported?
> 
> Or, more probably, it would print
>    ACPI: (supports S5)
Don't know what does it mean to support S0 exactly... :)
> as it is unlikely that "off" is not supported :-)
> 
> Maybe S0 should be taken outside the #ifdef and the loop as that state is 
> also basically always there?
Don't think it is worth the trouble. We already have this loop almost completely unrolled,
let's not make it complete mess...

Regards,
Alex.
> 
> Thanks,
> FJP
> 

