Return-Path: <linux-kernel-owner+w=401wt.eu-S939499AbXHJPQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939499AbXHJPQr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 11:16:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760297AbXHJPQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 11:16:37 -0400
Received: from cluster-g.mailcontrol.com ([85.115.41.190]:42994 "EHLO
	cluster-g.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753692AbXHJPQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 11:16:36 -0400
Message-ID: <46BC8083.9020506@csr.com>
Date: Fri, 10 Aug 2007 16:13:07 +0100
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Marcel Holtmann <marcel@holtmann.org>
CC: linux-kernel@vger.kernel.org, Nicolas Pitre <npitre@mvista.com>
Subject: Re: Driver for Bluetooth SDIO cards
References: <1186309908.5868.344.camel@violet>  <46BA02D6.9000108@csr.com>	 <1186662739.20129.170.camel@violet>  <46BB4C8F.4080007@csr.com>	 <1186683438.20129.183.camel@violet>  <46BC5C12.5070603@csr.com>	 <1186753060.20129.222.camel@violet>  <46BC7A2E.60502@csr.com> <1186758533.20129.234.camel@violet>
In-Reply-To: <1186758533.20129.234.camel@violet>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Aug 2007 15:13:21.0085 (UTC) FILETIME=[FCF8B6D0:01C7DB60]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Marcel Holtmann wrote:
> 
> In that case my card has TPL_SDIOBT_RTC set to 0x00. Does the BlueCore6
> implement Retry Control Support?

It should, but it doesn't work (with the current firmware) so we don't
enable it and always ack reads.

David
-- 
David Vrabel, Software Engineer, Drivers group  Tel: +44 (0)1223 692562
CSR plc, Churchill House, Cambridge Business Park, Cowley Road, CB4 0WZ


.
