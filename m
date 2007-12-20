Return-Path: <linux-kernel-owner+w=401wt.eu-S1759826AbXLTCOI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759826AbXLTCOI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 21:14:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755689AbXLTCNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 21:13:54 -0500
Received: from mail.prans.org ([64.79.206.200]:49178 "EHLO mail.prans.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753738AbXLTCNw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 21:13:52 -0500
From: Elvis Pranskevichus <el@prans.net>
To: Carlos Corbacho <carlos@strangeworlds.co.uk>
Subject: Re: [lm-sensors] 2.6.24-rc4 hwmon it87 probe fails
Date: Wed, 19 Dec 2007 21:13:22 -0500
User-Agent: KMail/1.9.7
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>, Jean Delvare <khali@linux-fr.org>,
       Shaohua Li <shaohua.li@intel.com>, Mike Houston <mikeserv@bmts.com>,
       Adrian Bunk <bunk@stusta.de>, mhoffman@lightlink.com,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
       Adam Belay <ambx1@neo.rr.com>, Zhao Yakui <yakui.zhao@intel.com>,
       Thomas Renninger <trenn@suse.de>, lenb@kernel.org,
       linux-acpi@vger.kernel.org
References: <20071204215154.7f26285e.mikeserv@bmts.com> <200712191720.23026.bjorn.helgaas@hp.com> <200712200045.16899.carlos@strangeworlds.co.uk>
In-Reply-To: <200712200045.16899.carlos@strangeworlds.co.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712192113.22974.el@prans.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday December 19 2007 07:45:14 pm Carlos Corbacho wrote:
> On Thursday 20 December 2007 00:20:21 Bjorn Helgaas wrote:
> > I suspect the manufacturers would say "Oh, the sensors?  The BIOS
> > isn't broken, you're just supposed to use WMI or some (undocumented)
> > ACPI device to get at those."
>
> It's quite possible - can we have DSDTs for the boards in question so we
> can quickly check if this is a possibility? (Basically, to see if they have
> PNP0C14 devices - if they don't, then I'm afraid it's nothing to do with
> WMI).
>
> -Carlos

Hi Carlos,

I've attached the DSDT for Gigabyte GA-965G-DS3 (rev 1.0, bios rev. F9) to 
bugzilla entry #9514:

http://bugzilla.kernel.org/attachment.cgi?id=14132

Thanks,
-- 
                Elvis
