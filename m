Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700Ab0CCP3D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 10:29:03 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:37369 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709Ab0CCP3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 10:29:00 -0500
Date: Wed, 3 Mar 2010 15:28:54 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Joey Lee <jlee@novell.com>
Cc: mzxreary@0pointer.de, gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 57/62] msi-laptop: Add threeg sysfs file for support
	query 3G state by standard 66/62 ec command
Message-ID: <20100303152854.GA29979@srcf.ucam.org>
References: <4B8F1A220200002300014185@novprvlin0050.provo.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B8F1A220200002300014185@novprvlin0050.provo.novell.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 03, 2010 at 08:25:38AM -0700, Joey Lee wrote:

> So, "wwan" does not mean "3g"? or 3g is included in "wwan"?
> And, does the "non-standard radio control file" mean like "threeg",
> "wlan" or "bluetooth" in /sys/devices/platform/xxxxx ?

wwan includes 3g, so it's the appropriate type to use here. The 
non-standard ones are the threeg, wlan and bluetooth files.

> In current x86/platform, there have a bit driver still used the
> "non-standard control file". Does that mean we need replace all of 
> those control files by rfkill interface?

Those are holdovers from before the rfkill interface was usable - we 
should probably be deprecating them. I /think/ all the drivers that 
provide them also provide an rfkill interface now, but if not we should 
probably port them.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
