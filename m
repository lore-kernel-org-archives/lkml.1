Return-Path: <linux-kernel-owner+w=401wt.eu-S933357AbXBES46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933357AbXBES46 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 13:56:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933360AbXBES46
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 13:56:58 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:38604 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933357AbXBES44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 13:56:56 -0500
Date: Mon, 5 Feb 2007 19:09:47 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Mark Lord <lkml@rtr.ca>
Cc: Patrick Ale <patrick.ale@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: hdparm for lib_pata
Message-ID: <20070205190947.680f2237@localhost.localdomain>
In-Reply-To: <45C773D6.3010009@rtr.ca>
References: <8d158e1f0702030041xaa34440r125a39a85d498f4c@mail.gmail.com>
	<45C773D6.3010009@rtr.ca>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Userspace PIO mode changes are NOT a good idea,

I would disagree there, but they are not high priority. We do need to
allow set_features/xfer but we need to snoop it and mode set properly
around it. There are cases you want to control this, more so admittedly
for DMA speeds.
