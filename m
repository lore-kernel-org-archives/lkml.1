Return-Path: <linux-kernel-owner+w=401wt.eu-S1752206AbZDPUZ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206AbZDPUZ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 16:25:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753110AbZDPUZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 16:25:44 -0400
Received: from rtr.ca ([76.10.145.34]:59324 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751975AbZDPUZn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 16:25:43 -0400
Message-ID: <49E79445.3080806@rtr.ca>
Date: Thu, 16 Apr 2009 16:25:41 -0400
From: Mark Lord <liml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Matthew Wilcox <willy@linux.intel.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       jgarzik@redhat.com
Subject: Re: [PATCH 5/5] libata: Add support for TRIM
References: <1238683047-13588-1-git-send-email-willy@linux.intel.com> <1238683047-13588-2-git-send-email-willy@linux.intel.com> <1238683047-13588-3-git-send-email-willy@linux.intel.com> <1238683047-13588-4-git-send-email-willy@linux.intel.com> <1238683047-13588-5-git-send-email-willy@linux.intel.com>
In-Reply-To: <1238683047-13588-5-git-send-email-willy@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
> ---
>  drivers/ata/libata-scsi.c |   46 +++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 46 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index b9747fa..d4c8b8b 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
...

It works.  :)

I'm using TRIM on a 120GB OCZ Vertex SSD here now,
and instrumented ata_discard_fn() to log what it does.
Seems to work perfectly, and the sector ranges for TRIM
match those given by "hdparm --fibmap" for the files I've tried.

Does this also TRIM metadata (eg. block bitmaps and the like) ?

Thanks Matthew (and others).
