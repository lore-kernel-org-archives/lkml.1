Return-Path: <linux-kernel-owner+w=401wt.eu-S1030314AbXEAJqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030314AbXEAJqe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 05:46:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031632AbXEAJqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 05:46:34 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:46816 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030314AbXEAJqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 05:46:33 -0400
Date: Tue, 1 May 2007 10:49:54 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: to something appropriate (was Re: 2.6.22 -mm merge plans)
Message-ID: <20070501104954.7bba79f0@the-village.bc.nu>
In-Reply-To: <46368062.6000100@garzik.org>
References: <20070430162007.ad46e153.akpm@linux-foundation.org>
	<46368062.6000100@garzik.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Tejun helpfully posted a bunch of clashing patches for all the ACPI 
> stuff :)  You might be better off dropping and getting a resend after 
> the dust settles.

Agree about the ACPI stuff.
 
> That LED trigger patch seems technically correct, but also filling a 
> need that few have.  IMO it craps up the hot path for little gain.

It only touches the affected devices and if its still an issue then it
should be via an arch define as well. Can you fire something off to the
submitter Jeff so we've got a direction ?

