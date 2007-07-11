Return-Path: <linux-kernel-owner+w=401wt.eu-S1761550AbXGKQiz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761550AbXGKQiz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 12:38:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754952AbXGKQis
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 12:38:48 -0400
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:51737 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754838AbXGKQir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 12:38:47 -0400
Date: Wed, 11 Jul 2007 09:41:59 -0700
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: Re: [PATCH 1/1] x86-64: introduce struct pci_sysdata to facilitate
 sharing of ->sysdata
In-reply-to: <20070711134514.GA4789@rhun.haifa.ibm.com>
To: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: Andi Kleen <ak@suse.de>, Jeff Garzik <jeff@garzik.org>,
       Andrew Morton <akpm@osdl.org>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jon Mason <jdmason@gmail.com>
Reply-to: Yinghai.Lu@Sun.COM
Message-id: <46950857.4010302@sun.com>
MIME-version: 1.0
Content-type: text/plain; format=flowed; charset=us-ascii
Content-transfer-encoding: 7BIT
References: <20070711134514.GA4789@rhun.haifa.ibm.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Muli Ben-Yehuda wrote:
> Andi, please consider applying for 2.6.23. Applies on top of the
> Calgary update I just sent out ("Calgary: more updates for 2.6.23").
> 
> This patch introduces struct pci_sysdata to x86 and x86-64, and
> converts the existing two users (NUMA, Calgary) to use it.
> 
> This lays the groundwork for having other users of sysdata, such as
> the PCI domains work.
> 
> The Calgary bits are tested, the NUMA bits just look ok.
> 
> Signed-off-by: Jeff Garzik <jeff@garzik.org>
> Signed-off-by: Muli Ben-Yehuda <muli@il.ibm.com>

how about acpi=off in x86_64 system?

You maybe update this with
http://lkml.org/lkml/2007/6/29/246
Andrew already sent that to Andi for 2.6.23

YH
