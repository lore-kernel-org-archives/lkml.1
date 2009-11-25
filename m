Return-Path: <linux-kernel-owner+w=401wt.eu-S1751674AbZKYOnA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751674AbZKYOnA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 09:43:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750883AbZKYOnA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 09:43:00 -0500
Received: from lo.gmane.org ([80.91.229.12]:38485 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750706AbZKYOm7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 09:42:59 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Matthieu CASTET <castet.matthieu@free.fr>
Subject: Re: =?utf-8?b?TU9EVUxFX0RFVklDRV9UQUJMRShpc2FwbnAs?= ...) does nothing
Date: Wed, 25 Nov 2009 14:42:43 +0000 (UTC)
Message-ID: <loom.20091125T141518-371@post.gmane.org>
References: <200911222201.59471.linux@rainbow-software.org>  <200911231359.54544.rusty@rustcorp.com.au> <s5h8wdxab2h.wl%tiwai@suse.de> <ac3eb2510911230613w5543e98bg4203a1fbd7269931@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 93.1.148.147 (Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.5) Gecko/20091112 Iceweasel/3.5.5 (like Firefox/3.5.5; Debian-3.5.5-1))
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Kay Sievers <kay.sievers <at> vrfy.org> writes:
> 
> No, we don't even have proper modaliases for the pnp bus
> (/sys/bus/pnp) and the alias string for pnp in the modules have a
> broken and unfixable format. PNP autoloading is all handled by the
> acpi modaliases these days. This is the first time in years I hear
> anybody asking for hotplug setups of plain old pnp devices. :)
> 
The naming is really bad. This as nothing to do with acpi : pnp and pnp_cards
entries are duplicated to another naming. And this should work on system 
without
acpi.
This should have been named to pnp2 or something like that.

Now I don't see why isapnp_device_id and pnp_card_device_id can't be merged
together.

For example most of alsa isa card use pnp_card_device_id and not 
isapnp_device_id.

Matthieu



