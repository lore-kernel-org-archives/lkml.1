Return-Path: <linux-kernel-owner+w=401wt.eu-S1755270AbXJIUFB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270AbXJIUFB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 16:05:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753038AbXJIUEw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 16:04:52 -0400
Received: from qb-out-0506.google.com ([72.14.204.232]:2830 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828AbXJIUEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 16:04:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=QsMSWcpC9zuSH6DNL5t5IcYzs83chlw5E3KD4Eofbb2Onjuwob0+TvVNsjAK7/spsxT/VZuH2NRX2HzMo6CSeB0GWw5+xpTpwUL1a9oo3fK9Ny9k+RUmOJigAPx7hvdy8CMPTeVgsLfRrO17XwHH+ohi/4fsj1+IVGO2KsNFTls=
Message-ID: <3efb10970710091304g30ab5549u84a092d4de40368b@mail.gmail.com>
Date: Tue, 9 Oct 2007 22:04:48 +0200
From: "Remy Bohmer" <linux@bohmer.net>
To: "John Sigler" <linux.kernel@free.fr>
Subject: Re: halt does not shut the system down
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       robert.moore@intel.com, len.brown@intel.com
In-Reply-To: <470B366F.4030306@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <470A58AF.9080402@free.fr> <470B366F.4030306@free.fr>
X-Google-Sender-Auth: 86dedf724deb2d08
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello John,

> John Sigler wrote:
> > When I run 'halt' the kernel prints:
> > Halting.
> > Shutdown: hdc
> > ACPI: PCI interrupt for device 0000:01:05.0 disabled
> > ACPI: PCI interrupt for device 0000:01:04.0 disabled
> > ACPI: PCI interrupt for device 0000:01:03.0 disabled
> > ACPI: PCI interrupt for device 0000:01:02.0 disabled
> > Power down.
> > acpi_power_off called
> >
> > But the system does not shut down. (The fans keep spinning, the LEDs

I have seen this behavior earlier on a system with the SMI interrupt
disabled. I do not know if this the case here, it is just a hint.
By the way, some distros bring the CPU in a halted state on a 'halt'
command, instead of powering off (actually very logical). For real
powering off these distros require the obvious 'poweroff' command.

Some long shots, maybe it helps...

Kind Regards,

Remy
