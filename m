Return-Path: <linux-kernel-owner+w=401wt.eu-S966479AbXEHRjd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966479AbXEHRjd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 13:39:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965948AbXEHRjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 13:39:31 -0400
Received: from [81.2.110.250] ([81.2.110.250]:36911 "EHLO the-village.bc.nu"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S965655AbXEHRja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 13:39:30 -0400
Date: Tue, 8 May 2007 18:42:56 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-scsi@vger.kernel.org,
       akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]: Fix old SCSI adapter crashes with CD-ROM (take 2)
Message-ID: <20070508184256.029cf8a4@the-village.bc.nu>
In-Reply-To: <1178642376.3737.36.camel@mulgrave.il.steeleye.com>
References: <20070508171710.1ac730cd@the-village.bc.nu>
	<20070508161444.GA4163@kernel.dk>
	<1178642376.3737.36.camel@mulgrave.il.steeleye.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Mike Christie tells me we're missing bouncing by accident in the
> scsi_execute path (but not the scsi_execute_async path).  He says this
> is the fix he proposed:
> 
> http://marc.info/?l=linux-scsi&m=115981479822790&w=2
> 
> Can we just merge this instead?

Short answer: No

Long answer - it doesn't take this path.

Different bug, both want fixing I suspect.
