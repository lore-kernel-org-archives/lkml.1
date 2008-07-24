Return-Path: <linux-kernel-owner+w=401wt.eu-S1757377AbYGXMjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757377AbYGXMjn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 08:39:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753052AbYGXMjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 08:39:31 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:43556 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754243AbYGXMja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 08:39:30 -0400
Message-ID: <488877C8.9020706@jp.fujitsu.com>
Date: Thu, 24 Jul 2008 21:38:32 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-list@drzeus.cx>
CC: LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
Subject: Re: post 2.6.26 requires pciehp_slot_with_bus
References: <20080724134737.4b91f30d@mjolnir.drzeus.cx>
In-Reply-To: <20080724134737.4b91f30d@mjolnir.drzeus.cx>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pierre,
(Added linux-pci to CC)

Pierre Ossman wrote:
> Somewhere post 2.6.26, pciehp started whining about not being able to
> claim the slot and error code -17. It suggested adding
> "pciehp_slot_with_bus", which actually helped. Still, having a kernel
> parameter should just be a temporary fix.

The "pciehp_slot_with_bus" option is a workaround for the platforms
that assign the same physical slot number to multiple slots. If your
system has PCI chassis and it supports Chassis Number registers,
maybe one of the solution is using chassis number + slot number as a
slot name. But I don't have any idea other than "pciehp_slot_with_bus"
if your system doesn't support chassis number.

Do you have any idea?

Thanks,
Kenji Kaneshige


