Return-Path: <linux-kernel-owner+w=401wt.eu-S935500AbXK3R2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935500AbXK3R2a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 12:28:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932633AbXK3R2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 12:28:14 -0500
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:43598 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763144AbXK3R2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 12:28:13 -0500
Message-ID: <4750480B.9010909@keyaccess.nl>
Date: Fri, 30 Nov 2007 18:27:39 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: trenn@suse.de
CC: Shaohua Li <shaohua.li@intel.com>, Dave Young <hidave.darkstar@gmail.com>,
       lenb@kernel.org, linux-acpi@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Zhao Yakui <yakui.zhao@intel.com>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Set pnp_init_resource_table, pnp_resource_change,	pnp_manual_config_dev
 deprecated
References: <a8e1da0711290111m65b071cft90b4361ec0155096@mail.gmail.com>	 <474F72E3.4040608@keyaccess.nl>	 <1196389939.7234.1.camel@sli10-desk.sh.intel.com> <1196417657.23251.293.camel@queen.suse.de>
In-Reply-To: <1196417657.23251.293.camel@queen.suse.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 30-11-07 11:14, Thomas Renninger wrote:

> This should be 2.6.24 material:
> 
> Mark pnp_init_resource_table, pnp_resource_change, pnp_manual_config_dev deprecated
> 
> Thanks to Rene Herman, the remaining calls to those functions got eliminated
> in the sound/isa layer recently.
> Those functions are a workaround for wrong BIOS pnp information and give
> drivers the possibility to override BIOS exported PNP resources.
> This can be done through sysfs since 2.6, therefore these functions should
> vanish rather soon, as dynamic allocation for PNP resources is depending
> on it.

I'll withhold an ack on this for now. The ALSA side patch has hit the ALSA 
repositories but wouldn't seem likely to end up in 2.6.24 at this point in 
the development cycle.

Can't have it deprecated with ALSA still using them...

Rene.
