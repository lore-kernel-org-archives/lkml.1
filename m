Return-Path: <linux-kernel-owner+w=401wt.eu-S1760750AbYHUV6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760750AbYHUV6q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 17:58:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760149AbYHUV63
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 17:58:29 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:46307 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760087AbYHUV61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 17:58:27 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: char/tpm: tpm_infineon no longer loaded for HP 2510p laptop
Date: Thu, 21 Aug 2008 15:58:23 -0600
User-Agent: KMail/1.9.9
Cc: ambx1@neo.rr.com, elendil@planet.nl, trenn@suse.de,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       tpm@selhorst.net, rjw@sisk.pl, greg@kroah.com
References: <24565067.73831219353513508.JavaMail.servlet@kundenserver>
In-Reply-To: <24565067.73831219353513508.JavaMail.servlet@kundenserver>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808211558.23725.bjorn.helgaas@hp.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 August 2008 03:18:33 pm Kay Sievers wrote:
> Bjorn Helgaas wrote:
> >Is there a "complete idiot's guide to modules
> >and udev"?  There's precious little in Documentation/ other than a bunch
> >of sample rules for various subsystems.
> 
> I don't know of any specific documentation, but it's pretty easy:
> ...

Thanks for the tutorial.

> >Could I fix this by implementing pnp_device_uevent()?
> 
> Only if we change the format of the current pnp device aliases
> to something like:
>   pnp*:XYZ2324:*
>   pnp*:ABC1234:*
> 
> and create a "modalias" file at every pnp device, and add MODALIAS to
> the uevent. The modalias must contains all ID's which belong to that
> device in one single string, separated and terminated by a special
> character, something like:
>   pnp:ABC1234:XYZ2324:RST3445:

This all sounds like good stuff that I'd like PNP to have.  Is there
any reason I shouldn't implement pnp_device_uevent()?  Any backwards-
compatibility issues?

I think that sounds like a better solution than doing this PNP ID
mangling.

Bjorn
