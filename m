Return-Path: <linux-kernel-owner+w=401wt.eu-S1758510AbYEGOSD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758510AbYEGOSD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 10:18:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755414AbYEGORr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 10:17:47 -0400
Received: from mjg.x.mythic-beasts.com ([93.93.128.6]:50277 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753929AbYEGORo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 10:17:44 -0400
Date: Wed, 7 May 2008 15:17:26 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Shaohua Li <shaohua.li@intel.com>, Holger Macht <hmacht@suse.de>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Accardi, Kristen C" <kristen.c.accardi@intel.com>
Message-ID: <20080507141726.GA11025@srcf.ucam.org>
References: <20080505202508.GA3690@homac> <20080506091522.GA4378@homac> <1210065811.12668.1.camel@sli10-desk.sh.intel.com> <20080506151846.GA22828@khazad-dum.debian.net> <1210122279.27316.2.camel@sli10-desk.sh.intel.com> <20080507011354.GA8163@khazad-dum.debian.net> <1210123658.30944.6.camel@sli10-desk.sh.intel.com> <20080507123715.GA19475@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080507123715.GA19475@khazad-dum.debian.net>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [PATCH] bay: Exit if notify handler cannot be installed
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2008 at 09:37:15AM -0300, Henrique de Moraes Holschuh wrote:

>   1a) those which notify you that the bay/dock is BEING ejected
>   1b) those which notify you the user wants to eject, and wait for
>       a command to power down the bay/dock and let the user know
>       she can remove the device.

I believe that docks are always in 1b, though bays may be in either. The 
only docks I've seen without an eject request aren't ACPI docks at all, 
so fall outside the scope of this.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
