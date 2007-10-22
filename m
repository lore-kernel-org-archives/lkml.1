Return-Path: <linux-kernel-owner+w=401wt.eu-S1753264AbXJVXtN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264AbXJVXtN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 19:49:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751202AbXJVXs6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 19:48:58 -0400
Received: from khc.piap.pl ([195.187.100.11]:34964 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125AbXJVXs5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 19:48:57 -0400
To: Daniel Barkalow <barkalow@iabervon.org>
Cc: Jeff Garzik <jeff@garzik.org>, Linas Vepstas <linas@austin.ibm.com>,
       Shane Huang <chunhao.huang@hotmail.com>, davem@davemloft.net,
       gregkh@suse.de, htejun@gmail.com, brice.goglin@gmail.com,
       david.gaarenstroom@gmail.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, shane.huang@amd.com,
       linux-ide@vger.kernel.org, Brice Goglin <brice@myri.com>
Subject: Re: [patch] PCI: disable MSI on more ATI NorthBridges
References: <BLU112-W5125F6D8BEB3DF6359D53E29F0@phx.gbl>
	<20071019195749.GK29903@austin.ibm.com> <471911BE.2000405@garzik.org>
	<Pine.LNX.4.64.0710221555190.32497@iabervon.org>
	<471D0ADC.7000005@garzik.org>
	<Pine.LNX.4.64.0710221700120.32497@iabervon.org>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Tue, 23 Oct 2007 01:48:54 +0200
In-Reply-To: <Pine.LNX.4.64.0710221700120.32497@iabervon.org> (Daniel Barkalow's message of "Mon, 22 Oct 2007 17:31:04 -0400 (EDT)")
Message-ID: <m3abqau2vt.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Barkalow <barkalow@iabervon.org> writes:

> 00:05.0 Audio device: nVidia Corporation MCP61 High Definition Audio (rev a2)
>
> will have the same issue, and use a multi-vendor driver.

I think MCP55 HDA did not have such problem, though I may be wrong
(AFAIR it worked with shared IRQ and with MSI).
-- 
Krzysztof Halasa
