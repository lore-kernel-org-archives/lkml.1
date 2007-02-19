Return-Path: <linux-kernel-owner+w=401wt.eu-S932674AbXBSVFV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932674AbXBSVFV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 16:05:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932686AbXBSVFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 16:05:21 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:58451 "EHLO
	localhost.localdomain" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932672AbXBSVFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 16:05:20 -0500
Date: Mon, 19 Feb 2007 22:08:12 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: Robert Hancock <hancockr@shaw.ca>,
       Tobias Diedrich <ranma+kernel@tdiedrich.de>,
       Linux Kernel ML <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
Subject: Re: pata_amd dropping to PIO on resume
Message-ID: <20070219220812.11c3baba@localhost.localdomain>
In-Reply-To: <45D6436C.4060209@garzik.org>
References: <fa.q7ZuddHInqn2dVlS+EWjXjPvFC8@ifi.uio.no>
	<45D63BCE.2080700@shaw.ca>
	<45D6436C.4060209@garzik.org>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Deleting the ata_pci_clear_simplex() call, then adding 
> ATA_FLAG_IGN_SIMPLEX to the ata_port_info info[] array, is also worth 
> trying.

I think I know what is going on here. Firstly the simplex bits
need re-clearing on a resume. On my todo list now I'm back
