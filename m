Return-Path: <linux-kernel-owner+w=401wt.eu-S1753625AbXC1JvO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625AbXC1JvO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 05:51:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753621AbXC1JvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 05:51:14 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:2436 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752885AbXC1JvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 05:51:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=su0RJS9GnEEYtfl6iKIVJ8lCXDxKyPgPjv9gYzkfVzZa8yy1QfQXgVfX48BJJb4LX4ObCNvicxltFngySO0LFaMlcuiTMCByDC8CW8RTq9aZ2M/7sjuMgVRhlg4mfFuEdvlLcFbfbp0UyZ7psMkCiGRPbmDBoD5Z8phPc0E4kDA=
Message-ID: <460A3A89.2050809@gmail.com>
Date: Wed, 28 Mar 2007 18:51:05 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Jeff Garzik <jeff@garzik.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan <alan@lxorguk.ukuu.org.uk>, Len Brown <lenb@kernel.org>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Subject: Re: ATA ACPI (was Re: Linux 2.6.21-rc5)
References: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org> <4608B0CA.1040005@garzik.org> <4608B1A2.3040305@gmail.com> <20070327213200.GA5842@ucw.cz>
In-Reply-To: <20070327213200.GA5842@ucw.cz>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Hi!
> 
>>>> So if you have reported a regression in the 2.6.21-rc 
>>>> series, please check 2.6.21-rc5, and update your 
>>>> report as appropriate (whether fixed or "still 
>>>> problems with xyzzy").
>>> [just got back from vacation, or would have sent this 
>>> earlier]
>>>
>>> FWIW, I'm still leaning towards disabling libata ACPI 
>>> support by default for 2.6.21.
>>>
>>> Upstream has Alan's fix for the worst PATA problems, 
>>> but for different reasons, I think PATA ACPI and SATA 
>>> ACPI support in libata does not feel quite ready for 
>>> prime time in 2.6.21.
>>>
>>> Scream now, or hold your peace until 2.6.22... :)
>> I second disabling ACPI for 2.6.21.
> 
> Ugh.. does that mean we'll have 'regression reports' as in 'it worked
> ok in -rc5, broken in final?
> 
> Well, suspend is currently so broken that we'll be flooded by reports,
> anyway, but.... could we get at least define in code so that we can
> tell users to flip it?

Just the default value for libata.noacpi is changed to 1, so user can
easily reenable it by passing boot/module parameter.

-- 
tejun
