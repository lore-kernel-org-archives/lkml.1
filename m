Return-Path: <linux-kernel-owner+w=401wt.eu-S933284AbXCKM1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933284AbXCKM1Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 08:27:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933281AbXCKM1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 08:27:25 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:45102 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933284AbXCKM1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 08:27:25 -0400
Date: Sun, 11 Mar 2007 13:31:08 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Robert Hancock <hancockr@shaw.ca>
Cc: Vitaliyi <imgrey@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: libata extension
Message-ID: <20070311133108.7dca0e7b@lxorguk.ukuu.org.uk>
In-Reply-To: <45F3B829.2010503@shaw.ca>
References: <fa.tUT8ZqaAp2RZveBFqwzUhq3UYGI@ifi.uio.no>
	<45F3B829.2010503@shaw.ca>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I believe you should be able to do this by sending ATA pass-through SCSI 
> commands into the device using SG_IO, without any kernel changes. It's 
> really the mechanism that's meant for this..

It should work, but Mark Lord reported some problems with READ_LONG on
PIIX/ICH intel chipsets. I don't know if he ever resolved them but if not
I have a patch that ought to.

Alan
