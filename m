Return-Path: <linux-kernel-owner+w=401wt.eu-S1758838AbYHDQid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758838AbYHDQid (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 12:38:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753931AbYHDQiY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 12:38:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:39204 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753776AbYHDQiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 12:38:24 -0400
Date: Mon, 4 Aug 2008 09:38:10 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Keith Packard <keithp@keithp.com>, Ingo Oeser <ioe-lkml@rameria.de>,
       John Stoffel <john@stoffel.org>, Christoph Hellwig <hch@infradead.org>,
       Eric Anholt <eric@anholt.net>, linux-kernel@vger.kernel.org
Subject: Re: files/process scaling problem? (was: [PATCH] Export
 shmem_file_setup and shmem_getpage for DRM-GEM)
Message-ID: <20080804093810.689c92fa@infradead.org>
In-Reply-To: <20080804151146.71d9fcce@lxorguk.ukuu.org.uk>
References: <1217573919-7496-1-git-send-email-eric@anholt.net>
	<18581.43362.460694.60862@stoffel.org>
	<1217785943.23437.330.camel@koto.keithp.com>
	<200808040135.32563.ioe-lkml@rameria.de>
	<1217809152.23437.401.camel@koto.keithp.com>
	<20080804091930.164f31c3@lxorguk.ukuu.org.uk>
	<20080804065101.6f70725a@infradead.org>
	<20080804151146.71d9fcce@lxorguk.ukuu.org.uk>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Aug 2008 15:11:46 +0100
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> On Mon, 4 Aug 2008 06:51:01 -0700
> > the hard part is that DRI is a library that gets linked into
> > existing applications... which already are using select ;-(
> > 
> > Fixing X is one thing and not impossible.. fixing all existing
> > games in the field is quite another
> 
> X libraries provide the event loop 

they do?
I could have sworn things like glib etc do their own...
but I'm no desktop guy so I can totally be wrong as well
