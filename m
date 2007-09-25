Return-Path: <linux-kernel-owner+w=401wt.eu-S1755631AbXIYHIw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755631AbXIYHIw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 03:08:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751356AbXIYHIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 03:08:43 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:41756 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119AbXIYHIm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 03:08:42 -0400
Message-ID: <46F8B3F8.1050909@garzik.org>
Date: Tue, 25 Sep 2007 03:08:40 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Peer Chen <peerchen@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ide <linux-ide@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH] sata_nv,ahci: add the ahci legacy mode support to sata_nv
References: <200709251323031982245@gmail.com>
In-Reply-To: <200709251323031982245@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Peer Chen wrote:
> Add the ahci controller legacy mode support to sata_nv.
> Move the DIDs of legacy mode from ahci.c to sata_nv.c
> 
> The patch base on kernel 2.6.23-rc8
> 
> Signed-off-by: Peer Chen <peerchen@gmail.com>

I don't understand why these are being moved?

If an interface can be driven via the AHCI driver, that is greatly 
preferred over the sata_nv driver.

	Jeff



