Return-Path: <linux-kernel-owner+w=401wt.eu-S1753782AbYE2IHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782AbYE2IHu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 04:07:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751698AbYE2IHe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 04:07:34 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:45539 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565AbYE2IHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 04:07:32 -0400
Date: Thu, 29 May 2008 09:07:19 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-input@vger.kernel.org, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, carlos@strangeworlds.co.uk
Message-ID: <20080529080719.GA16444@srcf.ucam.org>
References: <20080528132152.GB32646@srcf.ucam.org> <20080528132900.GC32646@srcf.ucam.org> <20080528224200.0c740819.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080528224200.0c740819.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: RESEND: [PATCH 3/3] Misc: Add HP WMI laptop extras driver
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2008 at 10:42:00PM -0700, Andrew Morton wrote:
> On Wed, 28 May 2008 14:34:25 +0100 Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > --- /dev/null
> > +++ b/drivers/misc/hp-wmi.c
> 
> I see no Kconfig or Makefile updates.

Oops. Will resend.

> > +static struct key_entry hp_wmi_keymap[] = {
> > +	{KE_SW, 0x01, SW_DOCK},
> > +	{KE_KEY, 0x02, KEY_BRIGHTNESSUP},
> > +	{KE_KEY, 0x03, KEY_BRIGHTNESSDOWN},
> > +	{KE_KEY, 0x04, KEY_HELP},
> > +	{KE_END, 0}
> > +};
> 
> Could be made const.  hp_wmi_input_setup() already honours that,
> others will need tweaks.

Not if we want to be able to set the keymap, surely?
-- 
Matthew Garrett | mjg59@srcf.ucam.org
