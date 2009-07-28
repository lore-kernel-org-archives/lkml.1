Return-Path: <linux-kernel-owner+w=401wt.eu-S1754192AbZG1NqX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192AbZG1NqX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 09:46:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754172AbZG1NqW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 09:46:22 -0400
Received: from mail.mnementh.co.uk ([173.45.232.4]:42162 "EHLO mnementh.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754150AbZG1NqW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 09:46:22 -0400
Message-ID: <4A6F0123.9040809@mnementh.co.uk>
Date: Tue, 28 Jul 2009 14:46:11 +0100
From: Ian Molton <ian@mnementh.co.uk>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: linux-kernel@vger.kernel.org, Magnus Damm <damm@opensource.se>,
       akpm@linux-foundation.org, Matt Fleming <matt@console-pimps.org>,
       Philip Langdale <philipl@overt.org>
Subject: Re: [PATCH] tmio_mmc: Optionally support using platform clock
References: <Pine.LNX.4.64.0907280937000.4943@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0907280937000.4943@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guennadi Liakhovetski wrote:
> If the platform device has a clock associated with the tmio-mmc device, 
> use it.

Sorry, I misread there.

I'm still not sure what to to about this though because we seem to be 
collecting numerous ways of passing clocks to this driver, this is the 
fourth, by my counting.

the clock API could cope with all of them by simply allowing the driver 
to claim CLK_MMC (or such) from its parent, except that it cant cope 
with both the platform and MFD code providing clocks. The parent could 
be either the TMIO MFD core (for TMIO MFDs) or the CPU/SoC whatever, it 
woudlnt matter.

In any case, still no, as with all the other TMIO clock code patches. 
This needs to be done properly.
