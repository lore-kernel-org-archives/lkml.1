Return-Path: <linux-kernel-owner+w=401wt.eu-S1761033AbXGPOGa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761033AbXGPOGa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 10:06:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932372AbXGPOFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 10:05:22 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:62496 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932503AbXGPOFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 10:05:19 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18075.31515.974905.507754@stoffel.org>
Date: Mon, 16 Jul 2007 10:05:15 -0400
From: "John Stoffel" <john@stoffel.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 00/33] SG table chaining support
In-Reply-To: <11845792671245-git-send-email-jens.axboe@oracle.com>
References: <11845792671245-git-send-email-jens.axboe@oracle.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Jens> A repost of this patchset, which adds support forchaining of sg
Jens> tables.  This enables much larger IO commands, since we don't
Jens> have to allocate large consecutive pieces of memory to represent
Jens> the sgtable of a huge command. Right now Linux is limited to
Jens> somewhere between 128 and 256 segments, depending on the
Jens> architecture. This translates into at most 512k-1mb request
Jens> sizes. With this patchset, I've successfully pushed 10MiB
Jens> commands through the IO stack.

Will this help out tape drive performance at all?  I looked through
the patches quickly, esp the AIC7xxx stuff since that's what I use,
but nothing jumped out at me...

John
