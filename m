Return-Path: <linux-kernel-owner+w=401wt.eu-S1755540AbYLaHSJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540AbYLaHSJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 02:18:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752027AbYLaHRz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 02:17:55 -0500
Received: from main.gmane.org ([80.91.229.2]:56606 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752024AbYLaHRz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 02:17:55 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: PCI resource collision message
Date: Wed, 31 Dec 2008 01:17:40 -0600
Message-ID: <495B1C94.7040907@shaw.ca>
References: <b681c62b0812302251p195debf5v360e1058de5c18e1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: s0106000c41bb86e1.ss.shawcable.net
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
In-Reply-To: <b681c62b0812302251p195debf5v360e1058de5c18e1@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

yogeshwar sonawane wrote:
> Hi all,
> 
> I have seen the following message in /var/log/messages file :-
> 
> PCI: Device 0000:01:00.0 not available because of resource collisions
> 
> Whenever this msg comes, the PCI card which is present in 0000:01:00.0
> is not useful/accessible.
> While detection of card, pci_set_master() fails.
> But after reboot, that msg goes & card is working fine.
> 
> This card is a Network controller PCI-Express based card.
> The above problem comes very rarely & not on all the test nodes. The
> situation may be difficult to reproduce.
> 
> So, my question is, what to interpret from the above message ?
> PCI bios allocates the PCI resources. So where to look to remove this error ?

Is there something overlapping in the PCI resource allocations? Can you 
post the lspci -vv output?

