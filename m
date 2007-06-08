Return-Path: <linux-kernel-owner+w=401wt.eu-S968944AbXFHNJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968944AbXFHNJd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 09:09:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968059AbXFHNJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 09:09:13 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:48213 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968016AbXFHNJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 09:09:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=dwnIsURJ0rZCsQemBiU9JAb7cSZQlnhUwWHktT5ytTQzx8g63qxv89Vl1xJR27RChLpDoOsRKT0zXiBXDm09adxt2MinKIZWixYtMWCrns14dASO/1VvzYw5jMknxOtUmD0Y6eu498Y+jncQ39gVS0nDf8MkEMgRqx8usN7HX4U=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH 1/1] ide: ide-generic, add another device exception
Date: Fri, 8 Jun 2007 14:18:55 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Korb <ml@akana.de>, linux-ide@vger.kernel.org
References: <20601315171560711667@wsc.cz>
In-Reply-To: <20601315171560711667@wsc.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706081418.56217.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 04 June 2007, Jiri Slaby wrote:
> ide-generic, add another device exception

ide-generic is a generic ISA IDE driver, this one is drivers/ide/pci/generic
(a generic IDE PCI driver) - fixed patch description to avoid confusion.

[ Yes, both drivers need a rename - patches are welcomed. ]

> This device is char device and is grabbed by generic ide driver:
> 00:0b.0 Class ffff: National Semiconductor Corporation 87410 IDE (rev ff) (prog-if ff)
> 	Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
> 
> Disallow generic driver to grab it by adding next condition. Also
> consolidate exceptions to one bigger 'switch (dev->vendor)'.
> 
> Cc: Ingo Korb <ml@akana.de>
> Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

applied, thanks.
