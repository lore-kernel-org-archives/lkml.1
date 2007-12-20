Return-Path: <linux-kernel-owner+w=401wt.eu-S1756519AbXLTArS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756519AbXLTArS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 19:47:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753552AbXLTArF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 19:47:05 -0500
Received: from slackadelic.com ([65.196.224.53]:60493 "EHLO
	mail.slackadelic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbXLTArE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 19:47:04 -0500
From: Carlos Corbacho <carlos@strangeworlds.co.uk>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: [lm-sensors] 2.6.24-rc4 hwmon it87 probe fails
Date: Thu, 20 Dec 2007 00:45:14 +0000
User-Agent: KMail/1.9.7
Cc: Jean Delvare <khali@linux-fr.org>, Shaohua Li <shaohua.li@intel.com>,
       Mike Houston <mikeserv@bmts.com>, Adrian Bunk <bunk@stusta.de>,
       Elvis Pranskevichus <el@prans.net>, mhoffman@lightlink.com,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
       Adam Belay <ambx1@neo.rr.com>, Zhao Yakui <yakui.zhao@intel.com>,
       Thomas Renninger <trenn@suse.de>, lenb@kernel.org,
       linux-acpi@vger.kernel.org
References: <20071204215154.7f26285e.mikeserv@bmts.com> <20071218185918.5d2d4c7d@hyperion.delvare> <200712191720.23026.bjorn.helgaas@hp.com>
In-Reply-To: <200712191720.23026.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712200045.16899.carlos@strangeworlds.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 December 2007 00:20:21 Bjorn Helgaas wrote:
> I suspect the manufacturers would say "Oh, the sensors?  The BIOS
> isn't broken, you're just supposed to use WMI or some (undocumented)
> ACPI device to get at those."

It's quite possible - can we have DSDTs for the boards in question so we can 
quickly check if this is a possibility? (Basically, to see if they have 
PNP0C14 devices - if they don't, then I'm afraid it's nothing to do with 
WMI).

-Carlos
-- 
E-Mail: carlos@strangeworlds.co.uk
Web: strangeworlds.co.uk
GPG Key ID: 0x23EE722D
