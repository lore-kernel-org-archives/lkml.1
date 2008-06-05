Return-Path: <linux-kernel-owner+w=401wt.eu-S1758121AbYFESTK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758121AbYFESTK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 14:19:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752272AbYFESTA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 14:19:00 -0400
Received: from ag-out-0708.google.com ([72.14.246.251]:45371 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691AbYFESTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 14:19:00 -0400
Message-ID: <fa686aa40806051118y39cbf14fye5268c819d4bbbfc@mail.gmail.com>
Date: Thu, 5 Jun 2008 12:18:56 -0600
From: "Grant Likely" <grant.likely@secretlab.ca>
To: avorontsov@ru.mvista.com
Subject: Re: [PATCH] [RFC v3] OF: OpenFirmware bindings for the mmc_spi driver
Cc: "Pierre Ossman" <drzeus-mmc@drzeus.cx>,
       "David Brownell" <dbrownell@users.sourceforge.net>,
       "Jochen Friedrich" <jochen@scram.de>,
       "Segher Boessenkool" <segher@kernel.crashing.org>,
       "Gary Jennejohn" <garyj@denx.de>,
       "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080605180058.GA21429@polina.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080605161624.GA517@polina.dev.rtsoft.ru>
	 <fa686aa40806050945h5e61910flb63a8d00e1d2b0e8@mail.gmail.com>
	 <20080605172723.GA14514@polina.dev.rtsoft.ru>
	 <fa686aa40806051036x22cd6a2bkc58650f5e69960fe@mail.gmail.com>
	 <20080605180058.GA21429@polina.dev.rtsoft.ru>
X-Google-Sender-Auth: d8eb40d09a5af812
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 5, 2008 at 12:00 PM, Anton Vorontsov
<avorontsov@ru.mvista.com> wrote:
> On Thu, Jun 05, 2008 at 11:36:09AM -0600, Grant Likely wrote:
>> On Thu, Jun 5, 2008 at 11:27 AM, Anton Vorontsov
>> <avorontsov@ru.mvista.com> wrote:
>> > Well, I mentioned the usb_add_hcd()-alike approach for the mmc_spi
>> > host... The absence of enthusiasm I equaled to "no".
>> >
>> > Heh.
>>
>> I'm allergic to USB HCD code; I was probably having convulsions under my desk.
>
> :-)
>
> Ok, I also mentioned drivers/ata/pata_of_platform.c (OF version is using
> common code from drivers/ata/pata_platform.c).
>
> Please look there, and tell me if this is what you have in mind. (ignore
> _probe in the __pata_platform_probe name. Imagine
> pata_platform_add_controller or something).

Yes, I like that.  I've done something very similar for drivers with
both of and non-of bindings.  For another example, this time all
contained within a single .c file, see drivers/video/xilinxfb.c

>> > p.s.
>> > Btw, you forgot another downside of v2 approach: struct spi_driver
>> > duplication... Not sure if everyone will be happy about it.
>> >
>> > Though, v2 is only version where we can make modular OF_MMC_SPI.
>>
>> I think we've got our wires crossed.  I'm not referring to the option
>> of an of_mmc_spi driver registering an mmc_spi device (which can then
>> be probed by the mmc_spi_driver).
>
> I'm not refrering to this option either.

Okay, I'm confused then.  Where is the duplication of struct spi_driver?

Cheers,
g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
