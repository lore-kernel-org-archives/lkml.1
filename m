Return-Path: <linux-kernel-owner+w=401wt.eu-S1753541AbYJUFzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541AbYJUFzw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 01:55:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751852AbYJUFzn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 01:55:43 -0400
Received: from avexch2.qlogic.com ([198.70.193.116]:41843 "EHLO
	avexch2.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597AbYJUFzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 01:55:42 -0400
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Message-Id: <2384AD26-4B33-47A5-ADC7-3D0E58431690@qlogic.com>
From: Anirban Chakraborty <anirban.chakraborty@qlogic.com>
To: Matthew Wilcox <matthew@wil.cx>
In-Reply-To: <20081021055107.GN26184@parisc-linux.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: Re: What's in pci-2.6.git
Date: Mon, 20 Oct 2008 22:55:41 -0700
References: <200810081521.10262.jbarnes@virtuousgeek.org> <34A54798-E6AE-42E4-AAE3-D6C918971D69@qlogic.com> <20081021055107.GN26184@parisc-linux.org>
X-Mailer: Apple Mail (2.929.2)
X-OriginalArrivalTime: 21 Oct 2008 05:55:36.0520 (UTC) FILETIME=[A377D480:01C93341]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 20, 2008, at 10:51 PM, Matthew Wilcox wrote:

> On Mon, Oct 20, 2008 at 10:18:38PM -0700, Anirban Chakraborty wrote:
>>> Arjan van de Ven (1):
>>>    PCI: introduce an pci_ioremap(pdev, barnr) function
>>
>> Does it make sense to rename iounmap to pci_iounmap, just to be
>> consistent with pci_ioremap_bar?
>
> iounmap can be used for ioremaps that aren't necessarily from PCI  
> devices.
> Since there's no length parameter to iounmap, there's nothing to get
> wrong, so there's no natural counterpart to pci_ioremap().

Yeah, that makes sense.
Thanks,
-Anirban
