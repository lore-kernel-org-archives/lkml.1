Return-Path: <linux-kernel-owner+w=401wt.eu-S1753436AbZIVXkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436AbZIVXkv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 19:40:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753193AbZIVXku
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 19:40:50 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:53032 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116AbZIVXkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 19:40:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=JIPWhq7UZ+UL9MbMuTRPzs8krkRZ2/Xu2kblSvp+pR63W8V7VIqQZMyCcWYHk/AaCR
         piOo3jzcSuvYWxUGW4oA9VHxULgrp2CnD/qUbGUi36WOTTjTJtpGbZyMth7wHgsa1Hvs
         4dcUuXsCa1ugaQH7di7t7KzyODTU+vsOS61AI=
Message-ID: <4AB95F41.1070500@lwfinger.net>
Date: Tue, 22 Sep 2009 18:35:29 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Gary Hade <garyhade@us.ibm.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: fixing "pci=use_crs"
References: <200909161715.24376.bjorn.helgaas@hp.com> <200909171016.50087.bjorn.helgaas@hp.com> <4AB50FF2.1070104@lwfinger.net> <200909211520.56800.bjorn.helgaas@hp.com>
In-Reply-To: <200909211520.56800.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn Helgaas wrote:
> On Saturday 19 September 2009 11:08:02 am Larry Finger wrote:
>> Bjorn Helgaas wrote:
>>> It looks like you have an HP box -- what exactly is it and
>>> what BIOS version do you have?  Maybe I can borrow one to play
>>> with myself so I don't have to bug you as much.
>> It is an HP dv2815nr. The BIOS is F.21. I understand that debugging
>> is much easier when you have the machine in hand, but I don't mind
>> providing information.
>> ...
>> Do you want me to boot with "pci=use_crs"?
> 
> That'd be great.  HP's bureaucracy makes it hard for me to borrow
> machines.  If you could also turn on CONFIG_PNP_DEBUG_MESSAGES
> and boot with "pnp.debug", we should get some clues about what _CRS
> returns for all the ACPI devices.  Just attach the resulting dmesg
> to the bugzilla (http://bugzilla.kernel.org/show_bug.cgi?id=14183).

I put the dmesg output with pci=use_crs and pnp.debug in the bugzilla.

Larry



