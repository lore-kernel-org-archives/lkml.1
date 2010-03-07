Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018Ab0CGWLy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 17:11:54 -0500
Received: from casper.infradead.org ([85.118.1.10]:54859 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798Ab0CGWLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 17:11:53 -0500
Date: Sun, 7 Mar 2010 14:11:50 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: linux-kernel@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH] async: Manage execution domains
Message-ID: <20100307141150.51b3518a@linux.intel.com>
In-Reply-To: <1267989149-10825-1-git-send-email-chris@chris-wilson.co.uk>
References: <1267989149-10825-1-git-send-email-chris@chris-wilson.co.uk>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun,  7 Mar 2010 19:12:29 +0000
Chris Wilson <chris@chris-wilson.co.uk> wrote:

> Currently execution domains do not interact well with full
> synchronisation requests. If the sync request is performed before the
> async task has begun, then the manager will never schedule() and so
> busy-wait forever on a UP box. By reorganising the tasks into both a
> per-domain and global list, we can either wait on a single execution
> domain or globally over all tasks, as intended.

the intention has never been to wait for all tasks, at least not for
tasks that have their own domain rather than using the global domain.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
