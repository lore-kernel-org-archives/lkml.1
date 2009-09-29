Return-Path: <linux-kernel-owner+w=401wt.eu-S1753970AbZI2L66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970AbZI2L66 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 07:58:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753913AbZI2L66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 07:58:58 -0400
Received: from casper.infradead.org ([85.118.1.10]:45129 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753690AbZI2L65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 07:58:57 -0400
Date: Tue, 29 Sep 2009 13:59:25 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: "Leonidas ." <leonidas137@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: GFP_NOWAIT and GFP_NOMEMALLOC
Message-ID: <20090929135925.50ac88bf@infradead.org>
In-Reply-To: <f22d86810909290425s46406fe5ib00bcfc9673f70df@mail.gmail.com>
References: <f22d86810909290425s46406fe5ib00bcfc9673f70df@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Sep 2009 16:55:24 +0530
"Leonidas ." <leonidas137@gmail.com> wrote:

> Hi list,
> 
> I am new here, I have googled/binged enough before posting this
> message, in case of redundancy please point me to appropriate
> links/resources etc.
> 
> I want to kmalloc memory while holding spinlocks in process context,
> here I can't use GFP_KERNEL flag since it can sleep. Using GFP_ATOMIC
> guarantees that allocation will succeed by allocating from emergency
> pools if needed. But I dont think, I need to use emergency pool and I
> want to limit my memory consumption to ZONE_NORMAL without sleeping,
> my module is ready to handle the allocation failure if any.

GFP_NOWAIT is what you want.

can you give us a pointer to what your module is about? Maybe there's
better solutions...


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
