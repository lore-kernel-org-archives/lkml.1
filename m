Return-Path: <linux-kernel-owner+w=401wt.eu-S1758885AbXKUNLd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758885AbXKUNLd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 08:11:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754687AbXKUNLX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 08:11:23 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49154 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754528AbXKUNLX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 08:11:23 -0500
To: Pavel Krauz <krauz@cncz.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: wrong NUMA detection on HP385 G2
From: Andi Kleen <andi@firstfloor.org>
References: <200711191543.30665.krauz@cncz.cz>
	<200711201506.39184.krauz@cncz.cz>
Date: Wed, 21 Nov 2007 14:11:21 +0100
In-Reply-To: <200711201506.39184.krauz@cncz.cz> (Pavel Krauz's message of "Tue\, 20 Nov 2007 15\:06\:38 +0100")
Message-ID: <p731wajbv5y.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Krauz <krauz@cncz.cz> writes:
>   256 65792 131328 196864 262400 327936 393472 459008 524544 590080 655616 721152 786688 
> Node: 0, start_pfn: 1048576, end_pfn: 1245183
>   Setting physnode_map array to node 0 for pfns:
>   1048576 1114112 1179648 
> get_memcfg_from_srat: assigning address to rsdp

Ah that's a 32bit kernel. 32bit NUMA was always broken except on
NUMAQ/some old Summit machines.  Also it's not very useful due to
32bit limitations. Don't use. If you want working NUMA use a 64bit
kernel.

-Andi
