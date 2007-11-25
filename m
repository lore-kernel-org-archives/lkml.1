Return-Path: <linux-kernel-owner+w=401wt.eu-S1754722AbXKYMgd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722AbXKYMgd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 07:36:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752741AbXKYMg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 07:36:26 -0500
Received: from mo-p07-ob.rzone.de ([81.169.146.188]:60777 "EHLO
	mo-p07-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752678AbXKYMgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 07:36:25 -0500
X-RZG-CLASS-ID: mo07
X-RZG-AUTH: iaL9KxG65sFyH/NRHEm13ZpWIsASIz2sPdozvvFHDyhV6nPi
Message-ID: <47496C43.4090109@tragetaschen.dyndns.org>
Date: Sun, 25 Nov 2007 13:36:19 +0100
From: Kai Ruhnau <kai@tragetaschen.dyndns.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071122)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Stephen Hemminger <shemminger@linux-foundation.org>,
       Simon Arlott <simon@fire.lp0.eu>,
       Francois Romieu <romieu@fr.zoreil.com>,
       LKML <linux-kernel@vger.kernel.org>, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: Bogus PCI vendor ID
References: <473F0FE0.3010501@tragetaschen.dyndns.org>	<20071117184030.GA5541@electric-eye.fr.zoreil.com>	<53552.simon.1195474940@5ec7c279.invalid>	<20071119092736.7cb21231@freepuppy.rosehill> <20071124202815.fed44890.akpm@linux-foundation.org>
In-Reply-To: <20071124202815.fed44890.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>>>> Kai Ruhnau <kai@tragetaschen.dyndns.org> :
>>>> [...]
>>>>         
>>>>> I have a problem with two of my PCI devices showing the wrong PCI vendor
>>>>> ID (0001) in vanilla kernels.
>>>>>           
>
> Please try CONFIG_PCI_MMCONFIG=n
>   

If this is the same like the kernel option 'pci=conf1', that fixes the
vendor IDs.

Kai

-- 
This signature is left as an exercise for the reader.

