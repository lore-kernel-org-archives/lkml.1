Return-Path: <linux-kernel-owner+w=401wt.eu-S933597AbXHJX0d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933597AbXHJX0d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 19:26:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756904AbXHJX0W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 19:26:22 -0400
Received: from palrel12.hp.com ([156.153.255.237]:35019 "EHLO palrel12.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753639AbXHJX0V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 19:26:21 -0400
Message-ID: <46BCF1AF.3080000@hp.com>
Date: Fri, 10 Aug 2007 16:15:59 -0700
From: Rick Jones <rick.jones2@hp.com>
User-Agent: Mozilla/5.0 (X11; U; HP-UX 9000/785; en-US; rv:1.7.13) Gecko/20060601
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
Cc: greearb@candelatech.com, jeff@garzik.org, auke-jan.h.kok@intel.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] Add ETHTOOL_[GS]FLAGS sub-ioctls
References: <46BCD47C.9060408@candelatech.com>	<20070810.151039.31642625.davem@davemloft.net>	<46BCE942.1030107@candelatech.com> <20070810.154601.98709831.davem@davemloft.net>
In-Reply-To: <20070810.154601.98709831.davem@davemloft.net>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Ben Greear <greearb@candelatech.com>
> Date: Fri, 10 Aug 2007 15:40:02 -0700
> 
> 
>>For GSO on output, is there a generic fallback for any driver that
>>does not specifically implement GSO?
> 
> 
> Absolutely, in fact that's mainly what it's there for.
> 
> I don't think there is any issue.  The knob is there via
> ethtool for people who really want to disable it.

Just to be paranoid (who me?) we are then at a point where what happened 
a couple months ago with forwarding between 10G and IPoIB won't happen 
again - where things failed because a 10G NIC had LRO enabled by default?

rick jones
