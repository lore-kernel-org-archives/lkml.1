Return-Path: <linux-kernel-owner+w=401wt.eu-S1754856AbYGGPsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856AbYGGPsj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 11:48:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753679AbYGGPsb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 11:48:31 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:34634 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753445AbYGGPsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 11:48:30 -0400
Message-ID: <48723ABB.4060009@s5r6.in-berlin.de>
Date: Mon, 07 Jul 2008 17:48:11 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.13) Gecko/20080313 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Gavin Shan <gshan@alcatel-lucent.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Tough Issue: kernel instruction corruption
References: <008101c8deaa$52cf19d0$01fca8c0@microsof60b8d6>
In-Reply-To: <008101c8deaa$52cf19d0$01fca8c0@microsof60b8d6>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gavin Shan wrote:
> I'm suspecting
> the kernel instructions were corrupted by DMA operations driving
> by those PCI devices with DMA capabality. 
> 
> Anybody have tried to protect kernel instructions from this case
> or have any ideas to protect kernel text section?

IOMMU hardware can give some protection.  Correctly working PCI devices
and _correct drivers_ would be good to have too.
-- 
Stefan Richter
-=====-==--- -=== --===
http://arcgraph.de/sr/
