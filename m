Return-Path: <linux-kernel-owner+w=401wt.eu-S1755148AbZCGPGx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148AbZCGPGx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 10:06:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753115AbZCGPGo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 10:06:44 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:48041 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760AbZCGPGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 10:06:43 -0500
Date: Sat, 7 Mar 2009 15:06:40 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] toshiba_acpi: Add full hotkey support
Message-ID: <20090307150640.GA3516@srcf.ucam.org>
References: <20090306003941.GA32403@srcf.ucam.org> <20090306005234.GA32539@srcf.ucam.org> <E1LfqwF-000B1G-00.arvidjaar-mail-ru@mx3.mail.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1LfqwF-000B1G-00.arvidjaar-mail-ru@mx3.mail.ru>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 07, 2009 at 10:27:09AM +0300, Andrey Borzenkov wrote:
> Matthew Garrett wrote:
> 
> > +	{KE_KEY, 0x13d, KEY_SLEEP},
> > +	{KE_KEY, 0x13e, KEY_SUSPEND},
> 
> I have two buttons marked with memory and disk pictures. When I press the 
> first one HAL emits "sleep" button event, for the the second one HAL emits 
> "hibernate" event. I am using KDE4 and neither works :) According to KDE4 
> developer, they implement "suspend" button as suspend to RAM. Just trying to 
> clarify which key this should be and whether HAL should be fixed.  (I opened 
> bug report for KDE4)

Yeah, I'm not really a KDE guy, so I'm not sure what's happening there.

> > +	{KE_KEY, 0x13f, KEY_SWITCHVIDEOMODE},
> 
> I wonder, who is supposed to act upon it? Is there any generic user space 
> agent who implements video output switching?

At present I don't believe so, no.

> > +	{KE_KEY, 0x140, KEY_BRIGHTNESSDOWN},
> > +	{KE_KEY, 0x141, KEY_BRIGHTNESSUP},
> > +	{KE_KEY, 0x142, KEY_WLAN},
> 
> Ditto. Theoretically Toshiba even supports turning off radio via HCI, but it 
> is again not clear who should actually initiate it.

Right. In some of these cases there's nothing that currently handles 
them, but userspace should probably get round to it at some point.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
