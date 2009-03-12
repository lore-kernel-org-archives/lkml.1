Return-Path: <linux-kernel-owner+w=401wt.eu-S1756050AbZCLVvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050AbZCLVvA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 17:51:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752118AbZCLVuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 17:50:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:57721 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999AbZCLVuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 17:50:50 -0400
Date: Thu, 12 Mar 2009 07:07:59 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "Giacomo A. Catenazzi" <cate@cateee.net>
Cc: Sitsofe Wheeler <sitsofe@yahoo.com>,
       Dragoslav Zaric <dragoslav.zaric.kd@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Linux* Processor Microcode Data File
Message-ID: <20090312070759.25d24ab0@infradead.org>
In-Reply-To: <49B8DDDF.8080708@cateee.net>
References: <2d05c4580903090243k6cf73ee9ubb6c4fccf0f07a2f@mail.gmail.com>
	<20090309141655.GA24213@silver.sucs.org>
	<20090309081109.376f7a7e@infradead.org>
	<20090309153449.GB24213@silver.sucs.org>
	<20090309095330.30278385@infradead.org>
	<49B8DDDF.8080708@cateee.net>
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

On Thu, 12 Mar 2009 11:03:11 +0100
"Giacomo A. Catenazzi" <cate@cateee.net> wrote:

> > 
> > there are various cases where microcode is needed (for example, when
> > you hotplug a new cpu); request_firmware() is just the right way to
> > do such things, and an initscript is just the wrong way
> 
> I don't agree ;-)
> I agree that request_firmware method is better than init.d scripts,
> but not that it is the right things. microcodes should be loaded at
> very beginning of boot process, so by BIOS, by GRUB or on hotpug
> event by request_firmware.

... and how do you do CPU hotplug then ?

> BTW: why do we have microcode loading modular?

only the legacy initscript part is modular afaik.



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
