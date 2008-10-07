Return-Path: <linux-kernel-owner+w=401wt.eu-S1753828AbYJGQfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828AbYJGQfs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 12:35:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754069AbYJGQfg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 12:35:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:58854 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753711AbYJGQff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 12:35:35 -0400
Date: Tue, 7 Oct 2008 09:35:30 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Mike Miller <mike.miller@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, JensAxboejens.axboe@oracle.com,
       LKML <linux-kernel@vger.kernel.org>,
       LKML-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 1 of 1] cciss: add procfs interface to rescan logical
 volumes
Message-ID: <20081007093530.1793a81b@infradead.org>
In-Reply-To: <20081007162454.GA12104@roadking.ldev.net>
References: <20081007162454.GA12104@roadking.ldev.net>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Oct 2008 11:24:54 -0500
Mike Miller <mike.miller@hp.com> wrote:

> Patch 1 of 1
> 
> This patch adds a procfs interface so users can force a rescan of the
> logical volumes attached to the controller. A new product uses Target
> Based Management (TBM) out-of-band for configuration purposes. With
> this method the driver has no way of knowing that something has
> changed, i.e., new logical volume(s) added or existing volumes
> deleted. This interface allows the user to echo "rescan volumes" >
> /proc/driver/cciss/ccissN to force the driver to rebuild our table of
> logical volumes. 
> Please consider this patch for inclusion.


I'll ask the obvious question (since you didn't address this)...
why is this a proc thing and not just a sysfs attribute of the device?


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
