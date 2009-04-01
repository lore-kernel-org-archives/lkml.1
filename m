Return-Path: <linux-kernel-owner+w=401wt.eu-S1759901AbZDARwB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759901AbZDARwB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 13:52:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756716AbZDARvr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 13:51:47 -0400
Received: from stargate.chelsio.com ([12.22.49.110]:5120 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756153AbZDARvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 13:51:46 -0400
Date: Wed, 01 Apr 2009 10:48:48 -0700
To: "David Miller" <davem@davemloft.net>
Subject: Re: [PATCH 2.6.30] cxgb3: clear shadow BAR registers
From: "Divy Le Ray" <divy@chelsio.com>
Organization: Chelsio Communications
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Content-Type: text/plain; format=flowed; delsp=yes; charset=iso-8859-15
MIME-Version: 1.0
References: <20090401005854.15175.44595.stgit@speedy5>
 <20090331.203457.210552824.davem@davemloft.net>
Content-Transfer-Encoding: 7bit
Message-ID: <op.urpyfmweduofyu@cayman.asicdesigners.com>
In-Reply-To: <20090331.203457.210552824.davem@davemloft.net>
User-Agent: Opera Mail/9.64 (Win32)
X-OriginalArrivalTime: 01 Apr 2009 17:51:42.0234 (UTC) FILETIME=[83F2FFA0:01C9B2F2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Mar 2009 20:34:57 -0700, David Miller <davem@davemloft.net>  
wrote:

> From: Divy Le Ray <divy@chelsio.com>
> Date: Tue, 31 Mar 2009 17:58:54 -0700
>
>> From: Divy Le Ray <divy@chelsio.com>
>>
>> Ensure that internal shadow BAR registers are cleared on 32-bit  
>> platforms.
>>
>> Signed-off-by: Divy Le Ray <divy@chelsio.com>
>
> Why is this a problem and why is it not possible to rely
> on these being setup to zero by either the BIOS or the PCI
> layer?
>
> At best this is a PCI quirk and not something that belongs
> in the driver.
>
> I'm not applying this.

Hi Dave,

You are right, this issue is motherboard specific and seems to have been  
fixed a loong time ago.
Sorry for the spam.

Cheers,
Divy



