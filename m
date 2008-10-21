Return-Path: <linux-kernel-owner+w=401wt.eu-S1751978AbYJUFSu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978AbYJUFSu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 01:18:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753113AbYJUFSk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 01:18:40 -0400
Received: from avexch2.qlogic.com ([198.70.193.116]:38307 "EHLO
	avexch2.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807AbYJUFSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 01:18:39 -0400
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Message-Id: <34A54798-E6AE-42E4-AAE3-D6C918971D69@qlogic.com>
From: Anirban Chakraborty <anirban.chakraborty@qlogic.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
In-Reply-To: <200810081521.10262.jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: Re: What's in pci-2.6.git
Date: Mon, 20 Oct 2008 22:18:38 -0700
References: <200810081521.10262.jbarnes@virtuousgeek.org>
X-Mailer: Apple Mail (2.929.2)
X-OriginalArrivalTime: 21 Oct 2008 05:18:33.0033 (UTC) FILETIME=[762AA390:01C9333C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 8, 2008, at 3:21 PM, Jesse Barnes wrote:

> Quite a few patches have queued up in my linux-next branch for  
> 2.6.28, and a
> couple of more are still pending (they've seen lots of review so  
> should be
> just about ready), specifically the I/O virtualization code and more  
> PCI slot
> driver fixes from Alex and Kenji-san.
>
> Full shortlog below, there's stuff all over the map...
>
> Jesse
>
> Alex Chiang (1):
>      PCI: connect struct pci_dev to struct pci_slot
>
> Andi Kleen (1):
>      PCI: Document that most pci options are shared between i386 and  
> x86-64
>
> Arjan van de Ven (1):
>      PCI: introduce an pci_ioremap(pdev, barnr) function

Does it make sense to rename iounmap to pci_iounmap, just to be  
consistent with pci_ioremap_bar?

-Anirban
