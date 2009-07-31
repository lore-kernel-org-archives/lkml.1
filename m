Return-Path: <linux-kernel-owner+w=401wt.eu-S1752551AbZGaQrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551AbZGaQrl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 12:47:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752478AbZGaQrl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 12:47:41 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52690 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752443AbZGaQrk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 12:47:40 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <200907311730.08804.elendil@planet.nl>
References: <200907311730.08804.elendil@planet.nl> <200907311227.20132.elendil@planet.nl> <17615.1249045054@redhat.com>
To: Frans Pop <elendil@planet.nl>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org,
       David Woodhouse <David.Woodhouse@intel.com>
Subject: Re: RomFS: enless loop during make oldconfig from 2.6.24 -> 2.6.31-rc4 (parisc)
Date: Fri, 31 Jul 2009 17:46:16 +0100
Message-ID: <18884.1249058776@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frans Pop <elendil@planet.nl> wrote:

> I've tried again too. With all defaults I cannot reproduce it either.
> But if I answer the questions below as follows, I do get the loop again:
> 
> Advanced netfilter configuration: N
> Wireless: N
> * sound drivers: N (* = "PCI","USB" and one or two others)
> Default ext3 to "data=ordered": Y

I still don't see it.  I have:

	# CONFIG_NETFILTER_ADVANCED is not set
	# CONFIG_WIRELESS is not set
	# CONFIG_SND_PCI is not set
	# CONFIG_SND_SPI is not set
	# CONFIG_SND_USB is not set
	# CONFIG_SND_GSC is not set
	# CONFIG_SND_SOC is not set
	CONFIG_EXT3_DEFAULTS_TO_ORDERED=y

Can you accept all the defaults, then delete the above symbols from .config
and run make oldconfig again, see if the problem crops up?

David
