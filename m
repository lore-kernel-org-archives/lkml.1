Return-Path: <linux-kernel-owner+w=401wt.eu-S1758114AbZC2Udr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758114AbZC2Udr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 16:33:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757569AbZC2Udc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 16:33:32 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55204 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753711AbZC2Uda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 16:33:30 -0400
Date: Sun, 29 Mar 2009 22:33:21 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Luca Tettamanti <kronos.it@gmail.com>
Cc: Hans de Goede <hdegoede@redhat.com>, linux-kernel@vger.kernel.org,
       Jean Delvare <khali@linux-fr.org>, Matthew Garrett <mjg@redhat.com>,
       Len Brown <lenb@kernel.org>, Thomas Renninger <trenn@suse.de>,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH] ACPI: add "auto" to acpi_enforce_resources
Message-ID: <20090329203321.GA31857@elf.ucw.cz>
References: <20090204142606.1823661b@hyperion.delvare> <20090204142015.GB3923@srcf.ucam.org> <20090210145716.105ab58b@hyperion.delvare> <20090210140829.GA25397@srcf.ucam.org> <49919E08.5050002@redhat.com> <20090210172408.400cacee@hyperion.delvare> <20090227132740.GF1482@ucw.cz> <68676e00903240539i119b6d26j516ee131d4cd6781@mail.gmail.com> <49C8DE51.2010103@redhat.com> <20090329201617.GA10303@dreamland.darkstar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090329201617.GA10303@dreamland.darkstar.lan>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2009-03-29 22:16:17, Luca Tettamanti wrote:
> Il Tue, Mar 24, 2009 at 02:21:21PM +0100, Hans de Goede ha scritto: 
> > On 03/24/2009 01:39 PM, Luca Tettamanti wrote:
> >> On Fri, Feb 27, 2009 at 2:27 PM, Pavel Machek<pavel@ucw.cz>  wrote:
> >>> Hi!
> >>>
> >>>>> For the record we have changed the default to strict in Fedora's
> >>>>> development branch, for 2 weeks or so now, including in the recently
> >>>>> released Fedora 11 release and we've had 0 complaints so far.
> >>>> Well, if the number of affected systems is small, this is good news.
> >>>> But this is only 2 weeks and one distribution, coverage isn't
> >>>> sufficient to claim anything yet IMHO.
> >>>>
> >>>> That being said... if there's a common consensus that switching to
> >>>> strict and dealing with fallouts is the best thing to do, and I'm the
> >>>> only one objecting to this, then I am ready to admit that I was wrong
> >>>> and let you proceed.
> >>> I believe that 'enable strict, deal with fallout' is the best
> >>> long-term strategy...
> >>
> >> Hello,
> >> the merge window for .30 is now open, what are we going to do with this issue?
> >>
> >
> > I think the consensus was to make the default strict and to merge the atk0110
> > driver, right?
> 
> Ok,
> here's a patch:
> ---
> The following patch changes the default value for option "acpi_enforce_resource"
> to strict. It enforces strict resource checking - disallowing access by native
> drivers to IO ports and memory regions claimed by ACPI firmware.
> 
> The patch is mainly aimed to block native hwmon drivers from touching
> monitoring chips that ACPI thinks it own.
> 
> Signed-off-by: Luca Tettamanti <kronos.it@gmail.com>

Acked-by: Pavel Machek <pavel@suse.cz>

> Index: b/Documentation/kernel-parameters.txt
> ===================================================================
> --- a/Documentation/kernel-parameters.txt	2009-03-29 15:47:28.000000000 +0200
> +++ b/Documentation/kernel-parameters.txt	2009-03-29 15:51:30.000000000 +0200
> @@ -259,6 +259,22 @@
>  			to assume that this machine's pmtimer latches its value
>  			and always returns good values.
>  
> +	acpi_enforce_resources=	[ACPI]
> +			{ strict,  lax, no }
			          ~ extra space here... probably not
worth fixing.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
