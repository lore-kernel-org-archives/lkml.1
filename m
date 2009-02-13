Return-Path: <linux-kernel-owner+w=401wt.eu-S1758944AbZBMNki@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758944AbZBMNki (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 08:40:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753935AbZBMNka
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 08:40:30 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:60137 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156AbZBMNk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 08:40:29 -0500
Date: Fri, 13 Feb 2009 13:40:24 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Peter Feuerer <peter@piie.net>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Acer Aspire One fan control
Message-ID: <20090213134024.GA26549@srcf.ucam.org>
References: <cone.1234471033.988571.5384.1000@mentalhome>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cone.1234471033.988571.5384.1000@mentalhome>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 12, 2009 at 09:37:13PM +0100, Peter Feuerer wrote:

> Do you think it makes sense to add it as seperate kernelmodule or should I 
> patch another module, e.g. the drivers/misc/acer-wmi.c module?
> Should I try also to add the functionality of the 
> /proc/acpi/thermal_zone/THRM/* things in my first patch? Or just submit the 
> general functionality for controlling the fan and add additional things 
> step by step?

That depends on how you're doing it. Is the code available somewhere? If 
these io ports are also used by the firmware then you'll need to find 
ACPI methods to call to perform the fan control. If there aren't any 
then it's not safe to have a driver to do this.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
