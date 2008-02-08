Return-Path: <linux-kernel-owner+w=401wt.eu-S1761846AbYBHAMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761846AbYBHAMi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 19:12:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752723AbYBHAM2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 19:12:28 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:5524 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670AbYBHAM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 19:12:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=ioSh4F7cv0leW/Imc2FjGt+RmQ5+3KjKabRgcrR3obBUEgKK8t66TCIbIkcjPZVoUygVJU7xW9mrP7xO2oQ+gf4VI34dzgd1ZwmCPN+fRkgBs5RtNhjurfE4R/Z0DcvPHQTXWUMSB5iGbWj82UuxHlvTKCXRTCehMukAIqLghBk=
Message-ID: <2c0942db0802071612r1b32f996jc26ac3792b8c31fc@mail.gmail.com>
Date: Thu, 7 Feb 2008 16:12:24 -0800
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Carlos Corbacho" <carlos@strangeworlds.co.uk>
Subject: Re: ACPI_WMI: worst config description of all times
Cc: "Pavel Machek" <pavel@ucw.cz>, "Len Brown" <lenb@kernel.org>,
       "kernel list" <linux-kernel@vger.kernel.org>,
       "Linux-pm mailing list" <linux-pm@lists.osdl.org>,
       linux-acpi@vger.kernel.org
In-Reply-To: <200802072351.32521.carlos@strangeworlds.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080207214715.GA15211@elf.ucw.cz>
	 <200802072318.28313.carlos@strangeworlds.co.uk>
	 <2c0942db0802071533l5c3b98fel90946b73f8a9586b@mail.gmail.com>
	 <200802072351.32521.carlos@strangeworlds.co.uk>
X-Google-Sender-Auth: a626be5e03fd7d70
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 7, 2008 3:51 PM, Carlos Corbacho <carlos@strangeworlds.co.uk> wrote:
> On Thursday 07 February 2008 23:33:54 Ray Lee wrote:
> > Do you have list of hardware/platforms that require this feature to
> > get the hardware to work? (acer abc123, tcm1100 xyz)
>
> I have a very long list of Acer laptops that are supported - which is far too
> long, and changes on far too much of a regular basis to put in there.
>
> Perhaps adding something like "This driver is also a required dependency to
> build the firmware specific drivers needed for many laptops, including Acer
> and HP machines"?

<nod>

> (There's currently another ACPI-WMI based driver in development related to
> more HP laptops, and acer-wmi also supports a handful of non-Acer laptops).
>
> I don't think explaining what WMI is, and how ACPI-WMI is related to it is
> that useful in Kconfig here; so I agree that further elaborating on the 'why'
> this should be enabled is definitely worth doing.
>
> > Better, if there are kernel drivers that require this (and currently
> > only those drivers), then have those kernel drivers enable ACPI WMI,
>
> Wouldn't that require 'select' though, and I'm led to believe that's seriously
> frowned upon these days?

Depends who you talk to. It's certainly the fodder for a yearly flamewar.

While I'm not trying to set you up for a firing squad, if you can show
that the only use this driver has is as underlying support for Acer/HP
xyz drivers, and that those drivers require this one, then that
situation really is what select is in there for. Anyone who argues
against using select in that case is really just arguing against the
mere existence of the kconfig select keyword itself.
