Return-Path: <linux-kernel-owner+w=401wt.eu-S935735AbYEVNkQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935735AbYEVNkQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 09:40:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760573AbYEVNkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 09:40:04 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:39250 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758249AbYEVNkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 09:40:03 -0400
Message-ID: <48357756.3060602@s5r6.in-berlin.de>
Date: Thu, 22 May 2008 15:38:30 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.13) Gecko/20080313 SeaMonkey/1.1.9
MIME-Version: 1.0
To: JiSheng Zhang <jszhang3@mail.ustc.edu.cn>
CC: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
       krh@redhat.com
Subject: Re: [PATCH] firewire: fix some broken hardware NMI interrupt
References: <411458028.04591@ustc.edu.cn>
In-Reply-To: <411458028.04591@ustc.edu.cn>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

JiSheng Zhang wrote:
>> From: Stefan Richter <stefanr@s5r6.in-berlin.de>
>> jszhang3@mail.ustc.edu.cn wrote:
>>> Some broken pci-1394 card does not clear completely on-chip memory during
>>> boot, it
>>> may cause pci parity error, then NMI interrupt.
>> 
>> Which card?
> hmm, one card using VIA chip.
>> 
>> Is the problem still present in linux-2.6.26-rc3?
> It seems that the problem disappeared. Thanks

Great, thanks for testing.

I hope this is now permanently fixed.  Should it ever appear again, just
tell us.
-- 
Stefan Richter
-=====-==--- -=-= =-==-
http://arcgraph.de/sr/
