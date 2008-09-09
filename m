Return-Path: <linux-kernel-owner+w=401wt.eu-S1754806AbYIIWVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806AbYIIWVh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 18:21:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752212AbYIIWV1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 18:21:27 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34876 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750926AbYIIWV1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 18:21:27 -0400
Message-ID: <48C6F644.9080905@redhat.com>
Date: Tue, 09 Sep 2008 18:18:44 -0400
From: Chuck Ebbert <cebbert@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, torvalds@osdl.org,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ahci: Fix long standing Marvell regressions
References: <20080903000538.7500eaf8@lxorguk.ukuu.org.uk>	<48BDCF09.7000603@garzik.org>	<20080903142941.3f25d235@lxorguk.ukuu.org.uk> <20080903144834.35276de7@lxorguk.ukuu.org.uk> <48C54EFF.3060603@garzik.org>
In-Reply-To: <48C54EFF.3060603@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> applied.  I edited the text a bit, for formatting and clarity only (see 
> attached)
> 
 >   ahci, pata_marvell: play nicely together

I can't see how that's going to work with a 6145 adapter and no PATA devices
attached. The AHCI driver will always defer to pata_marvell (unless
marvell_enable=1 is passed) and pata_marvell will defer to ahci when it doesn't
see any PATA devices.

