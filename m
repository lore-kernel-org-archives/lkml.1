Return-Path: <linux-kernel-owner+w=401wt.eu-S1754757AbYGNMjK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757AbYGNMjK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 08:39:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753273AbYGNMix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 08:38:53 -0400
Received: from casper.infradead.org ([85.118.1.10]:56590 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800AbYGNMiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 08:38:52 -0400
Subject: Re: [PATCH] qla1280: use request_firmware
From: Jaswinder Singh <jaswinder@infradead.org>
To: Jes Sorensen <jes@sgi.com>
Cc: LKML <linux-kernel@vger.kernel.org>, David Woodhouse <dwmw2@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       kernel-janitors <kernel-janitors@vger.kernel.org>,
       kernelnewbies <kernelnewbies@nl.linux.org>, linux-scsi@vger.kernel.org,
       hch@infradead.org
In-Reply-To: <487B1C73.5000202@sgi.com>
References: <1215770284.2733.10.camel@jaswinder.satnam>
	 <487B1C73.5000202@sgi.com>
Content-Type: text/plain
Date: Mon, 14 Jul 2008 18:08:08 +0530
Message-Id: <1216039088.10198.8.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jes,

On Mon, 2008-07-14 at 11:29 +0200, Jes Sorensen wrote:
> Jaswinder Singh wrote:
> > this is a first draft; please be kind :)
> > 
> > Firmware blob is little endian looks like this...
> > 	unsigned char  Version1
> > 	unsigned char  Version2
> > 	unsigned char  Version3
> > 	unsigned char  Padding
> > 	unsigned short start_address
> > 	unsigned short data
> 
> Hello,
> 
> As the maintainer of this driver I am going to say that I think this is
> a stupid change. 

We have not changed the data.
We are passing risc_code01 data by using request_firmware when required.

If you found some problem in the code, Please let me know.

Thank you,

Jaswinder Singh.


