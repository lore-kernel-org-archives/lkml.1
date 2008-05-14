Return-Path: <linux-kernel-owner+w=401wt.eu-S1759293AbYENCiI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759293AbYENCiI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 22:38:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751228AbYENChy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 22:37:54 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:57383 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751774AbYENChx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 22:37:53 -0400
Subject: Re: blk_queue_init_tags warning
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Linux-Scsi <linux-scsi@vger.kernel.org>
In-Reply-To: <86802c440805131900r2c3cca56sb45f80f26dc65780@mail.gmail.com>
References: <86802c440805131900r2c3cca56sb45f80f26dc65780@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 13 May 2008 21:37:49 -0500
Message-Id: <1210732670.3077.79.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-05-13 at 19:00 -0700, Yinghai Lu wrote:
> ------------[ cut here ]------------
> WARNING: at include/linux/blkdev.h:431 blk_queue_init_tags+0xfe/0x154()
> Modules linked in:
> Pid: 1509, comm: scsi_wq_0 Not tainted
> 2.6.26-rc1-sched-devel.git-x86-latest.git-00589-g5bb43f9-dirty #382

Fixed by aa94b5371f6f898558d9fa5690cc6e4bf917a572 in -rc2.

James


