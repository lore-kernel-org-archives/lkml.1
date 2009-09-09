Return-Path: <linux-kernel-owner+w=401wt.eu-S1754070AbZIITix@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070AbZIITix (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 15:38:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752809AbZIITiw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 15:38:52 -0400
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:45726 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752478AbZIITiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 15:38:52 -0400
Date: Wed, 9 Sep 2009 21:43:47 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Shane Arnold <clontarf_x@iinet.net.au>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Bringing up secondary rtl8169-based interface causes network
	hang/dma issues
Message-ID: <20090909194347.GA23507@electric-eye.fr.zoreil.com>
References: <4AA6506A.7040900@iinet.net.au> <20090908175550.GA30098@electric-eye.fr.zoreil.com> <4AA7EF39.6060800@iinet.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AA7EF39.6060800@iinet.net.au>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shane Arnold <clontarf_x@iinet.net.au> :
> Well it seems I have solved it by disabling APIC and MSI/MSI-X  
> interrupts. Both NIC's up and playing nicely.
>
> Now just to figure out why it's not communicating with anything...

How can we tell that the nic are playing nicely if they are not
communicating with anything (i.e. no change in the rx / tx packets
count nor in ethtool statistitcs) ?

It is a bit confusing.

-- 
Ueimor
