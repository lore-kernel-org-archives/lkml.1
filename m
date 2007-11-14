Return-Path: <linux-kernel-owner+w=401wt.eu-S1756757AbXKNRvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757AbXKNRvm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 12:51:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760283AbXKNRv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 12:51:29 -0500
Received: from mx1.redhat.com ([66.187.233.31]:47399 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762149AbXKNRv1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 12:51:27 -0500
Date: Wed, 14 Nov 2007 12:50:28 -0500
From: Alan Cox <alan@redhat.com>
To: Mark Lord <liml@rtr.ca>
Cc: Tejun Heo <htejun@gmail.com>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Sebastian Kemper <sebastian_ml@gmx.net>,
       Jeff Garzik <jgarzik@pobox.com>, Alan Cox <alan@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] libata-scsi:  be tolerant of 12-byte ATAPI commands in 16-byte CDBs
Message-ID: <20071114175028.GA9546@devserv.devel.redhat.com>
References: <20071113164323.GA5252@section-eight> <20071113212230.77cadecd@the-village.bc.nu> <20071113232859.GA4681@section-eight> <473B0FA2.5000102@rtr.ca> <20071114153852.GA9019@section-eight> <473B1B83.9020103@rtr.ca> <473B33F7.7030708@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <473B33F7.7030708@rtr.ca>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a Lloegr o'r rhif cofrestru 3798903
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2007 at 12:44:23PM -0500, Mark Lord wrote:
> Sebastian Kemper reported that issuing CD/DVD commands under libata
> is not fully compatible with ide-scsi.  In particular, the 
> GPCMD_SET_STREAMING
> was being rejected at the host level in some instances.
> 
> The reason is that libata-scsi insists upon the cmd_len field exactly 
> matching
> the SCSI opcode being issued, whereas ide-scsi tolerates 12-byte commands
> contained within a 16-byte (cmd_len) CDB.
> 
> There doesn't seem to be a good reason for us to not be compatible there,
> so here is a patch to fix libata-scsi to permit SCSI opcodes so long as
> they fit within whatever size CDB is provided.
> 
> Signed-off-by: Mark Lord <mlord@pobox.com>

Acked-by: Alan Cox <alan@redhat.com>

