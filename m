Return-Path: <linux-kernel-owner+w=401wt.eu-S1759832AbXLNTuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759832AbXLNTuZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 14:50:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754727AbXLNTuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 14:50:07 -0500
Received: from mx1.redhat.com ([66.187.233.31]:56889 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751285AbXLNTuE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 14:50:04 -0500
Date: Fri, 14 Dec 2007 11:49:38 -0800
From: Pete Zaitcev <zaitcev@redhat.com>
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
       dm-devel@redhat.com, j-nomura@ce.jp.nec.com, zaitcev@redhat.com
Subject: Re: [PATCH 12/30] blk_end_request: changing ub (take 4)
Message-Id: <20071214114938.b87883af.zaitcev@redhat.com>
In-Reply-To: <20071214.120454.39153297.k-ueda@ct.jp.nec.com>
References: <20071211154803.58beb681.zaitcev@redhat.com>
	<20071212.153815.39152138.k-ueda@ct.jp.nec.com>
	<20071213135916.27ebe3f9.zaitcev@redhat.com>
	<20071214.120454.39153297.k-ueda@ct.jp.nec.com>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Dec 2007 12:04:54 -0500 (EST), Kiyoshi Ueda <k-ueda@ct.jp.nec.com> wrote:

> I have investigated all code paths which call ub_end_rq() in ub.c,
> and confirmed that ub_end_rq() is always called with the queue lock
> held.  (sc->lock is registered as a queue lock.)

Thanks for reminding me about blk_init_queue, I forgot. Sorry for the
confusion.

Greetings,
-- Pete
