Return-Path: <linux-kernel-owner+w=401wt.eu-S1753737AbYFWXUh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737AbYFWXUh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 19:20:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754063AbYFWXUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 19:20:17 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:39288 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753997AbYFWXUO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 19:20:14 -0400
Message-ID: <48602FA8.7090508@garzik.org>
Date: Mon, 23 Jun 2008 19:20:08 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, davem@davemloft.net
Subject: Re: [RESEND PATCH 1/3] e1000e: set CONFIG_E1000E=y in x86	defconfigs
References: <20080622221916.5907.79563.stgit@localhost.localdomain> <20080623112618.GC7485@elte.hu>
In-Reply-To: <20080623112618.GC7485@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jeff Kirsher <jeffrey.t.kirsher@intel.com> wrote:
> 
>> From: Auke Kok <auke-jan.h.kok@intel.com>
>>
>> This adds to the already default CONFIG_E1000=y in these files.
>>
>> Signed-off-by: Auke Kok <auke-jan.h.kok@intel.com>
>> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
>> ---
>>
>>  arch/x86/configs/i386_defconfig   |    1 +
>>  arch/x86/configs/x86_64_defconfig |    1 +
> 
> that is not an e1000 patch but an arch/x86 defconfig patch. NAK on this 
> route of patch propagation.

But it's dependent on an e1000 patch.  Maybe we could follow the lead of 
ppc and other arch maintainers, and work together?

Typically if there are arch dependencies and little drivers/net changes, 
I'll ACK the drivers/net change and then let it go through the arch tree.

In this case, there is far more drivers/net code, so it would make the 
most sense to work with you to change the defconfigs to your liking, and 
then merge them via netdev when the other E1000 changes go in.

	Jeff




