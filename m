Return-Path: <linux-kernel-owner+w=401wt.eu-S1757562AbZAVKYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757562AbZAVKYY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 05:24:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755491AbZAVKYQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 05:24:16 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:19361 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754659AbZAVKYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 05:24:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=xees2HLH9d9QjetlrOsD5OpbKiJFlyHwx+JC6/Ct4al2vOY/FJ+xawwulsNWh4oW4T
         qmN/T9HJThI2rZ1tuiCPeiCvmR687NFintO2dUdjhT4Xb3WSnr1IF/Z4lnSMfFcPNAyq
         yyCZxc6OjzFqyXi9Ej1BTRBcvvSIoD6tc80uo=
Message-ID: <4978499E.2040808@gmail.com>
Date: Thu, 22 Jan 2009 11:25:34 +0100
From: Jacek Luczak <difrost.kernel@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081209)
MIME-Version: 1.0
To: Alexey Starikovskiy <astarikovskiy@suse.de>
CC: LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       len.brown@intel.com
Subject: Re: [ACPI] GPE storm detected on FS Amilo Pro
References: <4977352B.1040303@gmail.com> <49778AAF.5000604@suse.de>
In-Reply-To: <49778AAF.5000604@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex,

Alexey Starikovskiy pisze:
> Hi Jacek,
> 
> You did not receive "GPE storm detected" message in earlier kernel only
> because
> there was no detection of it. You can check if you have one by enabling
> "#define DEBUG" at the beginning of the /drivers/acpi/ec.c and looking
> into dmesg.

I know, I was bit confused as I've seen that message before. I've double checked
and found that it appeared while I was fixing some stuff in 2.6.26 release
cycle, mea culpa.

> If there is no storm,
> you should see ony 2-3 interrupt messages per single transaction. Storm
> detector fires up at 8 excess interrupts.
> 

thanks for your answer, it was exactly what I was looking for.

While I was doing that 2.6.26 work I've found that IRQ 19 (sata ahci chip) is
doing some ugly stuff, I've reported that and stopped in half of my debug as I
didn't had more time to work on that. There was some ,,nobody cared'' bugs and
so one, I will return to that problem now and check if it's still present. All
those IRQ problems were appearing with suspend/resume. Nevertheless it isn't a
point here.

-Jacek
