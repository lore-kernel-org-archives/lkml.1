Return-Path: <linux-kernel-owner+w=401wt.eu-S1760194AbXEJMfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760194AbXEJMfZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 08:35:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751600AbXEJMfP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 08:35:15 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:47410 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751349AbXEJMfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 08:35:14 -0400
Date: Thu, 10 May 2007 13:38:51 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 11/13] SCSI: support for allocating large scatterlists
Message-ID: <20070510133851.6555cde9@the-village.bc.nu>
In-Reply-To: <11787925161084-git-send-email-jens.axboe@oracle.com>
References: <11787925152319-git-send-email-jens.axboe@oracle.com>
	<11787925161084-git-send-email-jens.axboe@oracle.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> sgtable that doesn't fit in a single page, allocate several
> SCSI_MAX_SG_SEGMENTS sized tables and chain them together.
> 
> We default to the safe setup of NOT chaining, for now.

Presumably you'll be submitting patches to fix the current I/O failure
retry in the SCSI layer before enabling it so that we retry most of a
problem I/O and don't throw 64MB of database data into the wind on a
single bad disk block ?

