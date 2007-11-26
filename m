Return-Path: <linux-kernel-owner+w=401wt.eu-S1757950AbXKZQ6Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757950AbXKZQ6Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 11:58:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754280AbXKZQ57
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 11:57:59 -0500
Received: from mx1.redhat.com ([66.187.233.31]:47999 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754153AbXKZQ56 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 11:57:58 -0500
Message-ID: <474AF9D9.8070209@redhat.com>
Date: Mon, 26 Nov 2007 11:52:41 -0500
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Jay Cliburn <jacliburn@bellsouth.net>
CC: greg@kroah.com, chrisw@sous-sol.org, kronos.it@gmail.com,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [2.6.22.y][PATCH] atl1: disable broken 64-bit DMA
References: <20071124191518.GA3672@osprey.hogchain.net>
In-Reply-To: <20071124191518.GA3672@osprey.hogchain.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jay Cliburn wrote:
> atl1: disable broken 64-bit DMA
> 
> [ Upstream commit: 5f08e46b621a769e52a9545a23ab1d5fb2aec1d4 ]
> 
> The L1 network chip can DMA to 64-bit addresses, but multiple descriptor
> rings share a single register for the high 32 bits of their address, so
> only a single, aligned, 4 GB physical address range can be used at a time.
> As a result, we need to confine the driver to a 32-bit DMA mask, otherwise
> we see occasional data corruption errors in systems containing 4 or more
> gigabytes of RAM.
> 
> Signed-off-by: Jay Cliburn <jacliburn@bellsouth.net>
> Cc: Luca Tettamanti <kronos.it@gmail.com>
> Cc: Chris Snook <csnook@redhat.com>

Acked-By: Chris Snook <csnook@redhat.com>
