Return-Path: <linux-kernel-owner+w=401wt.eu-S1946451AbXBINyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946451AbXBINyW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 08:54:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946465AbXBINyW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 08:54:22 -0500
Received: from wr-out-0506.google.com ([64.233.184.239]:18383 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946451AbXBINyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 08:54:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=PtKOTTY5VJvou/rg8yDuhXHO0HXuO0bdpf6glENlLiUcpUF2pNLpaHSxHY4CFn7LqAOyp+w2K9ZbsFHFMPgJwLihVemWVUXUCf1DQoE4wiyKAysOYtz7VEDDAxp0S9ZSLLDpn4mIKyu8LsrirCPLdkBRykQvEco/l6yAc72GywY=
Message-ID: <45CC7D04.5090403@gmail.com>
Date: Fri, 09 Feb 2007 08:54:12 -0500
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Emmeran Seehuber <rototor@rototor.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.18.2: sporadic SATA port resets (Broadcom BCM5785 (HT1000))
References: <200702071817.17006.rototor@rototor.de> <45CC3C9C.3050101@gmail.com> <200702091237.24576.rototor@rototor.de>
In-Reply-To: <200702091237.24576.rototor@rototor.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Emmeran Seehuber wrote:
>>> Does somebody have a glue whats going on here? Could it be a hardware
>>> failure?
>> It might be.  Quite some SATA bug reports turn out to be hardware
>> problem, most commonly PSU issues.
> 
> The power supply unit (you meant this with PSU, didn`t you?) has 800 Watt, so 
> it should be powerfull enough for one harddisk and no graphics board.

I see.

>>> Do you need additional information?
>> Yeah, please post the content of /var/log/boot.msg if available and the
>> result of dmesg and lspci -nn.
> 
> We don`t have a /var/log/boot.msg, but it seems the boot messages were saved 
> in /var/log/dmesg, so I attached it.

Yeap, that's exactly what I wanted.  So, the driver is sata_svw and 
errors are timeouts for both reads and writes with BMDMA engine still 
running.  It looks like transmission errors to me.  Can you post the 
result of 'smartctl -a /dev/sdX'?

-- 
tejun
