Return-Path: <linux-kernel-owner+w=401wt.eu-S1757662AbXLLRri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757662AbXLLRri (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 12:47:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751965AbXLLRrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 12:47:14 -0500
Received: from mailbox2.myri.com ([64.172.73.26]:1830 "EHLO myri.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751859AbXLLRrM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 12:47:12 -0500
Message-ID: <47601CF3.6030802@myri.com>
Date: Wed, 12 Dec 2007 12:40:03 -0500
From: Andrew Gallatin <gallatin@myri.com>
User-Agent: Thunderbird 1.5.0.7 (Macintosh/20060909)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: joonwpark81@gmail.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, jgarzik@pobox.com,
       shemminger@linux-foundation.org
Subject: Re: [RFC] net: napi fix
References: <47601A73.5010804@myri.com> <20071212.093819.205755031.davem@davemloft.net>
In-Reply-To: <20071212.093819.205755031.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Andrew Gallatin <gallatin@myri.com>
> Date: Wed, 12 Dec 2007 12:29:23 -0500
> 
>> Is the netif_running() check even required?
> 
> No, it is not.
> 
> When a device is brought down, one of the first things
> that happens is that we wait for all pending NAPI polls
> to complete, then block any new polls from starting.

Great, thanks.  I will submit a patch to remove the bogus
check.  This should fix myri10ge properly.


Thank you,

Drew
