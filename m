Return-Path: <linux-kernel-owner+w=401wt.eu-S1759315AbZFOONI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759315AbZFOONI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 10:13:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751689AbZFOOM5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 10:12:57 -0400
Received: from casper.infradead.org ([85.118.1.10]:57682 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173AbZFOOM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 10:12:56 -0400
Date: Mon, 15 Jun 2009 07:13:06 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH] WARN(): add a \n to the message printk
Message-ID: <20090615071306.5656aaa0@infradead.org>
In-Reply-To: <20090615100951.1571bf03@lxorguk.ukuu.org.uk>
References: <20090615000822.6e6bf282@infradead.org>
	<20090615100951.1571bf03@lxorguk.ukuu.org.uk>
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

On Mon, 15 Jun 2009 10:09:51 +0100
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > +	if (args) {
> >  		vprintk(args->fmt, args->args);
> > +		printk("\n");
> 
> What stops another printk occuring between those two ?
> 

absolutely nothing... and in that case you get what you get in a
million other places in the kernel; a bit of a mix.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
