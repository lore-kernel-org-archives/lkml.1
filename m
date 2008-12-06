Return-Path: <linux-kernel-owner+w=401wt.eu-S1753476AbYLFUaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476AbYLFUaS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 15:30:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752713AbYLFUaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 15:30:05 -0500
Received: from main.gmane.org ([80.91.229.2]:43081 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752711AbYLFUaD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 15:30:03 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: LibATA error
Date: Sat, 06 Dec 2008 14:29:19 -0600
Message-ID: <493AE09F.5010108@shaw.ca>
References: <20081206185252.GA4323@ics.muni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: s0106000c41bb86e1.ss.shawcable.net
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
In-Reply-To: <20081206185252.GA4323@ics.muni.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lukas Hejtmanek wrote:
> Hello,
> 
> what does the following error mean? Does it mean that my shiny new SSD is
> buggy?
> 
> [  461.382432] ata1.00: exception Emask 0x2 SAct 0x1 SErr 0x2000000 action 0x6
> frozen
> [  461.382484] ata1.00: irq_stat 0x00000010, unknown FIS 00000000 00000000
> 00000000 00000000
> [  461.382534] ata1: SError: { UnrecFIS }
> [  461.382572] ata1.00: cmd 61/08:00:0f:82:de/00:00:00:00:00/40 tag 0 ncq 4096
> out
> [  461.382574]          res 40/00:00:0f:82:de/00:00:00:00:00/40 Emask 0x2 (HSM
> violation)
> [  461.382666] ata1.00: status: { DRDY }
> [  461.382702] ata1: hard resetting link
> [  461.700087] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> 

It could be.. it means the drive sent the controller a SATA FIS (frame 
information structure) it didn't recognize.

