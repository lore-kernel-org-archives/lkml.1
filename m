Return-Path: <linux-kernel-owner+w=401wt.eu-S1753559AbZCIPKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559AbZCIPKe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 11:10:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751910AbZCIPK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 11:10:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:54564 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759AbZCIPKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 11:10:25 -0400
Date: Mon, 9 Mar 2009 08:11:09 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: Dragoslav Zaric <dragoslav.zaric.kd@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Linux* Processor Microcode Data File
Message-ID: <20090309081109.376f7a7e@infradead.org>
In-Reply-To: <20090309141655.GA24213@silver.sucs.org>
References: <2d05c4580903090243k6cf73ee9ubb6c4fccf0f07a2f@mail.gmail.com>
	<20090309141655.GA24213@silver.sucs.org>
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

On Mon, 9 Mar 2009 14:16:55 +0000
Sitsofe Wheeler <sitsofe@yahoo.com> wrote:

> On Mon, Mar 09, 2009 at 10:43:57AM +0100, Dragoslav Zaric wrote:
> 
> > So, does new kernel versions just copy this microcode update file in
> > /etc/firmware folder or new
> > instructions are replaced in assembly code ?
> 
> The kernel doesn't load microcode automatically 


it does if you have the right format; the kernel uses
request_firmware() for this.
The microcode on the intel website is not ready for this yet, but we're
working hard to have future drops to be in the new format.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
