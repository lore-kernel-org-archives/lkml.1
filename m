Return-Path: <linux-kernel-owner+w=401wt.eu-S1758924AbYDLB1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758924AbYDLB1n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 21:27:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756054AbYDLB1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 21:27:32 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:6622 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755535AbYDLB1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 21:27:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=YuykxT4GvRP8+M1NKW5y7CUFlay7wRmDaFBWmbzphg5seXPzB8bRz1GPQWhSisbpwfwExPnUqLj3vqFkMxdImS/jhfl1OZEkqC8mVhKSJv4WvZ/j5SEgk5f/ePctIMGwXNOHjuMQw7B1c82/h7u/72npy3wbDCFDh+1QSpkx7hw=
Message-ID: <48000FF8.300@gmail.com>
Date: Sat, 12 Apr 2008 10:27:20 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Volker Armin Hemmann <volker.armin.hemmann@tu-clausthal.de>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Peer Chen <pchen@nvidia.com>, Kuan Luo <kluo@nvidia.com>
Subject: Re: 2.6.24.X: SATA/AHCI related boot delay. - not with 2.6.24.3
References: <200803091922.33083.volker.armin.hemmann@tu-clausthal.de> <200804031347.20352.volker.armin.hemmann@tu-clausthal.de> <47FEFFC6.4@gmail.com> <200804111355.55364.volker.armin.hemmann@tu-clausthal.de>
In-Reply-To: <200804111355.55364.volker.armin.hemmann@tu-clausthal.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Volker Armin Hemmann wrote:
> Hi,
> 
>> Aiee.... Can you please try 2.6.25-rc8 with both configurations?  And
>> w/o systemrescuecd?  Just seeing whether things mount properly or not is
>> good enough.  There isn't much risk of losing data.
> 
> 2.6.25-rc8 is a 'no change'. AHCI+pci=nomsi boots, AHCI without hangs.
> with AHCI I also get this:
> 
> [    0.363828] ------------[ cut here ]------------
> [    0.363828] WARNING: at drivers/ata/ahci.c:645 ahci_init_one+0x190/0xa3a()
> [    0.363828] Modules linked in:
> [    0.363828] Pid: 1, comm: swapper Not tainted 2.6.25-rc8 #2

Heh.. that's AHCI_EN not getting set.  Peer, any ideas?  The driver set 
AHCI_EN in the HOST_CTL register but on reading back it's still clear.

Thanks.

-- 
tejun
