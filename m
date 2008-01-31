Return-Path: <linux-kernel-owner+w=401wt.eu-S934518AbYAaRky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934518AbYAaRky (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 12:40:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934185AbYAaRkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 12:40:08 -0500
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:36031 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934161AbYAaRkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 12:40:06 -0500
Message-ID: <47A20736.1080404@panasas.com>
Date: Thu, 31 Jan 2008 19:36:54 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, linux-scsi <linux-scsi@vger.kernel.org>,
       James Bottomley <James.Bottomley@SteelEye.com>
CC: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [build bug] drivers/scsi/NCR53C9x.c:913: error: 'Scsi_Cmnd' has
 no member named 'use_sg'
References: <20080131172901.GA8589@elte.hu>
In-Reply-To: <20080131172901.GA8589@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31 2008 at 19:29 +0200, Ingo Molnar <mingo@elte.hu> wrote:
> FYI, automated testing found the following build breakage:
> 
> drivers/scsi/NCR53C9x.c: In function 'esp_get_dmabufs':
> drivers/scsi/NCR53C9x.c:913: error: 'Scsi_Cmnd' has no member named 'use_sg'
> drivers/scsi/NCR53C9x.c:914: error: 'Scsi_Cmnd' has no member named 'request_bufflen'
> 
> config attached.
> 
> 	Ingo
> 
Cc linux-scsi mailing list.

This driver and others are scheduled to be removed in the scsi-pending tree
and are awaiting ACKs from - disappeared - maintainers.

Boaz

