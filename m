Return-Path: <linux-kernel-owner+w=401wt.eu-S1752863AbYKXTJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863AbYKXTJg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 14:09:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753752AbYKXTJI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 14:09:08 -0500
Received: from mail01.solnet.ch ([212.101.4.135]:64545 "EHLO mail01.solnet.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751904AbYKXTJE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 14:09:04 -0500
Subject: Re: [PATCH 1/1] cpufreq: eeepc 900 frequency scaling driver
From: Cristiano Prisciandaro <cristiano.p@solnet.ch>
To: Tom Hughes <tom@compton.nu>
Cc: Dave Jones <davej@redhat.com>, cpufreq@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <492A7632.4040106@compton.nu>
References: <1227454026.7262.59.camel@localhost>
	 <492A7632.4040106@compton.nu>
Content-Type: text/plain
Date: Mon, 24 Nov 2008 20:09:01 +0100
Message-Id: <1227553741.6709.75.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-11-24 at 09:38 +0000, Tom Hughes wrote:
> Cristiano Prisciandaro wrote:
> 
> > The bios of the eeepc 900 exposes an acpi method that allows clocking
> > the cpu to 630/900 MHz. This driver allows controlling the frequency
> > switch through the cpufreq subsystem.
> 
> I should perhaps add at this point that I have an alternative patch 
> based on Cristiano's code, which adds this cpufreq driver to the 
> existing eeepc-laptop module rather than creating a separate module for it.
> 
> Personally I'm quite happy with either solution so I'll leave it to you 
> to decide what is the best way to go, but my patch is available if you 
> want it.

If this functionality has chances to be included into the kernel then I
have no problems if as a module or integrated in eeepc-laptop. 

At the time of writing this module there was just the asus-acpi one:
I preferred not to mess with it.

     Cristiano



