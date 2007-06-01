Return-Path: <linux-kernel-owner+w=401wt.eu-S1764123AbXFAUYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764123AbXFAUYX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 16:24:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760692AbXFAUYS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 16:24:18 -0400
Received: from one.firstfloor.org ([213.235.205.2]:46704 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762231AbXFAUYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 16:24:17 -0400
Date: Fri, 1 Jun 2007 22:24:16 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Andi Kleen <andi@firstfloor.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       linux-kernel@vger.kernel.org
Subject: Re: Intel's response Linux/MTRR/8GB Memory Support / Why doesn't the kernel realize the BIOS has problems and re-map appropriately?
Message-ID: <20070601202416.GL7217@one.firstfloor.org>
References: <Pine.LNX.4.64.0706011410130.3716@p34.internal.lan> <200706011210.15808.jbarnes@virtuousgeek.org> <p73k5unbcnq.fsf@bingen.suse.de> <Pine.LNX.4.64.0706011618270.7446@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706011618270.7446@p34.internal.lan>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 1. The MCH/ICH8 hub 'requires' a minimum of 512MB to run, the board manual 
> states it needs at least 512MB of memort.
> 2. The DVT/IGP graphics uses either 128MB or 256MB, I have it set to 
> 128MB.
> 
> How can the Linux kernel find this out/poll this information so users do 
> not have to know mem=XXXXM?

I don't think it should. The Linux kernel is not trying to be
a BIOS replacement and should not know everything about the platforms
it runs on.   We sometimes try to work around very common
bugs, but this one (involving lots of memory and special configuration)
seems to be more in the exotic range where command line options
or waiting for a BIOS update seem better options.

-Andi
