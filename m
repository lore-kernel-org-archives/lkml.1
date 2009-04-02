Return-Path: <linux-kernel-owner+w=401wt.eu-S1761290AbZDBCFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761290AbZDBCFj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 22:05:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758146AbZDBCF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 22:05:26 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:38257 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756207AbZDBCFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 22:05:25 -0400
Message-ID: <49D41D5C.7070601@garzik.org>
Date: Wed, 01 Apr 2009 22:05:16 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
CC: linux-fsdevel@vger.kernel.org, axboe@kernel.dk,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] osdblk: a Linux block device for OSD objects
References: <20090402015455.GA14087@havoc.gtf.org>
In-Reply-To: <20090402015455.GA14087@havoc.gtf.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> As I promised in older exofs threads, here is a client for libosd
> _other_ than exofs.  This block driver exports a single OSD object
> as a Linux block device.

It should be noted that the first handful of functions are duplicates of 
fs/exofs/osd.c; an obvious consolidation is in order.

	Jeff




