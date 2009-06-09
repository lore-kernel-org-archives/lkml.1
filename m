Return-Path: <linux-kernel-owner+w=401wt.eu-S1755263AbZFIDsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263AbZFIDsS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 23:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753202AbZFIDsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 23:48:05 -0400
Received: from brick.kernel.dk ([93.163.65.50]:59667 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751467AbZFIDsE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 23:48:04 -0400
Date: Tue, 9 Jun 2009 05:48:06 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: scameron@beardog.cca.cpqcorp.net
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       akpm@linux-foundation.org, mikem@beardog.cca.cpqcorp.net
Subject: Re: [patch 1/8] cciss: Use schedule_timeout_uninterruptible in
	SCSI error handling code
Message-ID: <20090609034805.GV11363@kernel.dk>
References: <20090608205938.GG23523@beardog.cca.cpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090608205938.GG23523@beardog.cca.cpqcorp.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 08 2009, scameron@beardog.cca.cpqcorp.net wrote:
> 
> 
> Use schedule_timeout_uninterruptible instead of schedule_timeout in the
> scsi error handling code when waiting between TUR polls since we are not
> interested in nor want to be interrupted by signals.

Thanks Steve, applied 1-8.

-- 
Jens Axboe

