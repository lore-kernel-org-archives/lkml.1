Return-Path: <linux-kernel-owner+w=401wt.eu-S1752575Ab0ATGDI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575Ab0ATGDI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 01:03:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751721Ab0ATGDH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 01:03:07 -0500
Received: from casper.infradead.org ([85.118.1.10]:42444 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250Ab0ATGDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 01:03:06 -0500
Date: Tue, 19 Jan 2010 22:03:03 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, avi@redhat.com,
       johannes@sipsolutions.net, andi@firstfloor.org,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 32/40] async: introduce workqueue based alternative
 implementation
Message-ID: <20100119220303.6767a553@linux.intel.com>
In-Reply-To: <4B566590.5030804@kernel.org>
References: <1263776272-382-1-git-send-email-tj@kernel.org>
	<1263776272-382-33-git-send-email-tj@kernel.org>
	<20100117220130.214d56f1@linux.intel.com>
	<4B5420A3.3080200@kernel.org>
	<20100118072523.2683cd59@linux.intel.com>
	<4B55038D.3070106@kernel.org>
	<4B550384.8030103@linux.intel.com>
	<4B5565BE.4050406@kernel.org>
	<20100119063718.3f1f39cc@linux.intel.com>
	<4B564C23.1030708@kernel.org>
	<4B564ECC.9080707@linux.intel.com>
	<4B566590.5030804@kernel.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jan 2010 11:08:16 +0900
Tejun Heo <tj@kernel.org> wrote:

> 
> Yeap, but then again, whatever we do, all those synchronization
> interfaces can be mapped onto each other eventually.

and maybe we need to be smart about this;
for me, sharing the backend implementation (the pool part) makes sense,
although a thread pool really is not much code. But a smart thread pool
may be.

as for interfaces, I really really think it's ok to have different
interfaces for usecases that are very different, as long as the
interfaces are logical in their domain. I rather have 2 interfaces, each
logical to their domain, than a forced joined interface that doesn't
really naturally fit either.




-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
