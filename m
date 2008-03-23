Return-Path: <linux-kernel-owner+w=401wt.eu-S1757529AbYCWDaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757529AbYCWDaa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 23:30:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753719AbYCWDaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 23:30:19 -0400
Received: from rv-out-0910.google.com ([209.85.198.187]:57676 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753599AbYCWDaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 23:30:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=UFq154c0L/DlmrHCTSYmofG1xkmwP7A/oJtnAjYR894VQ0oAAFYgCuBvWmRU1DBJPKc2EEJ2UpL0B6INBc07kfeYd4M1ejwRWvtfHo+oZV5OuiFra59XrPi4xTiprPd2dPVMK90TCpk3qAUpoDZXOseQ232GiYxQs9/Rgrjo1Ho=
Message-ID: <86802c440803222030m31ffbb71v622b3e735966a9bf@mail.gmail.com>
Date: Sat, 22 Mar 2008 20:30:18 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "H. Peter Anvin" <hpa@kernel.org>, myles@mouselemur.cs.byu.edu
Subject: Re: ohci1394 problem (MMIO broken) (was 2.6.25-rc6-git6: Reported regressions from 2.6.24)
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Stefan Richter" <stefanr@s5r6.in-berlin.de>,
       "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Ivan Kokshaysky" <ink@jurassic.park.msu.ru>,
       "Thomas Meyer" <thomas@m3y3r.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>, "Adrian Bunk" <bunk@kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Natalie Protasevich" <protasnb@gmail.com>
In-Reply-To: <47E5C2C8.9030201@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200803220259.48534.rjw@sisk.pl> <47E540E7.7030108@m3y3r.de>
	 <47E54FA6.3060809@s5r6.in-berlin.de>
	 <47E557D5.9020604@s5r6.in-berlin.de>
	 <alpine.LFD.1.00.0803221423060.3020@woody.linux-foundation.org>
	 <47E5815B.4080002@kernel.org>
	 <86802c440803221628p60ebab7co3c4a6c1bef39d709@mail.gmail.com>
	 <47E596DE.2090801@kernel.org>
	 <86802c440803221900w1516e565yc6e5e26293acf5fe@mail.gmail.com>
	 <47E5C2C8.9030201@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 22, 2008 at 7:39 PM, H. Peter Anvin <hpa@kernel.org> wrote:
>
> Yinghai Lu wrote:
>  > On Sat, Mar 22, 2008 at 4:31 PM, H. Peter Anvin <hpa@kernel.org> wrote:
>  >> Yinghai Lu wrote:
>  >>  > Opteron system with coprocessor on socket or HTX slot. will use 64bit
>  >>  > BAR above 4g and size is more than 4g too.
>  >>
>  >>  And it's working, with a 32-bit kernel?
>  >
>  > don't think so.
>
>  Would you mind trying it out, with Linus' patch?

myles may test that with 32 bit kernel on his setup.

YH
