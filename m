Return-Path: <linux-kernel-owner+w=401wt.eu-S1754499AbZCIQw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499AbZCIQw6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 12:52:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751649AbZCIQws
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 12:52:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:45554 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194AbZCIQwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 12:52:47 -0400
Date: Mon, 9 Mar 2009 09:53:30 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: Dragoslav Zaric <dragoslav.zaric.kd@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Linux* Processor Microcode Data File
Message-ID: <20090309095330.30278385@infradead.org>
In-Reply-To: <20090309153449.GB24213@silver.sucs.org>
References: <2d05c4580903090243k6cf73ee9ubb6c4fccf0f07a2f@mail.gmail.com>
	<20090309141655.GA24213@silver.sucs.org>
	<20090309081109.376f7a7e@infradead.org>
	<20090309153449.GB24213@silver.sucs.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Mar 2009 15:34:50 +0000
Sitsofe Wheeler <sitsofe@yahoo.com> wrote:

> On Mon, Mar 09, 2009 at 08:11:09AM -0700, Arjan van de Ven wrote:
> > On Mon, 9 Mar 2009 14:16:55 +0000
> > Sitsofe Wheeler <sitsofe@yahoo.com> wrote:
> > 
> > > The kernel doesn't load microcode automatically 
> > 
> > it does if you have the right format; the kernel uses
> > request_firmware() for this.
> > The microcode on the intel website is not ready for this yet, but
> > we're working hard to have future drops to be in the new format.
> 
> Wow so I was redundant AND wrong in the same email!
> 
> What motivated the switch to the generic request_firmware interface?
> Is it just less messy/faster than previous methods? 

there are various cases where microcode is needed (for example, when
you hotplug a new cpu); request_firmware() is just the right way to do
such things, and an initscript is just the wrong way

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
