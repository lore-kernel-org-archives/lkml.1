Return-Path: <linux-kernel-owner+w=401wt.eu-S932785AbYBGXv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932785AbYBGXv7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 18:51:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757085AbYBGXvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 18:51:49 -0500
Received: from cyberslack.slackadelic.com ([216.23.240.152]:57862 "EHLO
	mail.slackadelic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318AbYBGXvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 18:51:48 -0500
From: Carlos Corbacho <carlos@strangeworlds.co.uk>
To: "Ray Lee" <ray-lk@madrabbit.org>
Subject: Re: ACPI_WMI: worst config description of all times
Date: Thu, 7 Feb 2008 23:51:31 +0000
User-Agent: KMail/1.9.7
Cc: "Pavel Machek" <pavel@ucw.cz>, "Len Brown" <lenb@kernel.org>,
       "kernel list" <linux-kernel@vger.kernel.org>,
       "Linux-pm mailing list" <linux-pm@lists.osdl.org>,
       linux-acpi@vger.kernel.org
References: <20080207214715.GA15211@elf.ucw.cz> <200802072318.28313.carlos@strangeworlds.co.uk> <2c0942db0802071533l5c3b98fel90946b73f8a9586b@mail.gmail.com>
In-Reply-To: <2c0942db0802071533l5c3b98fel90946b73f8a9586b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802072351.32521.carlos@strangeworlds.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 February 2008 23:33:54 Ray Lee wrote:
> Do you have list of hardware/platforms that require this feature to
> get the hardware to work? (acer abc123, tcm1100 xyz)

I have a very long list of Acer laptops that are supported - which is far too 
long, and changes on far too much of a regular basis to put in there.

Perhaps adding something like "This driver is also a required dependency to 
build the firmware specific drivers needed for many laptops, including Acer 
and HP machines"?

(There's currently another ACPI-WMI based driver in development related to 
more HP laptops, and acer-wmi also supports a handful of non-Acer laptops).

I don't think explaining what WMI is, and how ACPI-WMI is related to it is 
that useful in Kconfig here; so I agree that further elaborating on the 'why' 
this should be enabled is definitely worth doing.

> Better, if there are kernel drivers that require this (and currently
> only those drivers), then have those kernel drivers enable ACPI WMI,

Wouldn't that require 'select' though, and I'm led to believe that's seriously 
frowned upon these days?

-Carlos
-- 
E-Mail: carlos@strangeworlds.co.uk
Web: strangeworlds.co.uk
GPG Key ID: 0x23EE722D
