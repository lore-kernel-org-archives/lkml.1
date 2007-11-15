Return-Path: <linux-kernel-owner+w=401wt.eu-S1757538AbXKOC0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757538AbXKOC0Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 21:26:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755073AbXKOC0Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 21:26:16 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:21224 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055AbXKOC0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 21:26:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=DFqa86VdJoVqRfReDtEXqiAQpGowdM940omc3BOBms0FqE5aHuNTm9fFsyBqpfxNj+/IYDFcJtseyoG1YZHNltT6EpKFnPXU50YVJq4XSNNlxKV8ai7rr4zV175bMQvyu7jk5DoGIPAuMUzcVrxNzXQ1XEFq2trOv4CC07eIT3c=
Message-ID: <473BAE3B.2050906@gmail.com>
Date: Thu, 15 Nov 2007 11:26:03 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Mark Lord <liml@rtr.ca>
CC: IDE/ATA development list <linux-ide@vger.kernel.org>,
       Sebastian Kemper <sebastian_ml@gmx.net>,
       Jeff Garzik <jgarzik@pobox.com>, Alan Cox <alan@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] libata-scsi:  be tolerant of 12-byte ATAPI commands in
 16-byte CDBs
References: <20071113164323.GA5252@section-eight> <20071113212230.77cadecd@the-village.bc.nu> <20071113232859.GA4681@section-eight> <473B0FA2.5000102@rtr.ca> <20071114153852.GA9019@section-eight> <473B1B83.9020103@rtr.ca> <473B33F7.7030708@rtr.ca>
In-Reply-To: <473B33F7.7030708@rtr.ca>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
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

applied to #tj-upstream-fixes.

-- 
tejun
