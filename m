Return-Path: <linux-kernel-owner+w=401wt.eu-S1757448AbXFYP13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757448AbXFYP13 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 11:27:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756860AbXFYP1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 11:27:13 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:46129 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756808AbXFYP1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 11:27:12 -0400
Subject: Re: Linux Kernel include files
From: Arjan van de Ven <arjan@infradead.org>
To: Joerg Schilling <Joerg.Schilling@fokus.fraunhofer.de>
Cc: schilling@fokus.fraunhofer.de, linux-kernel@vger.kernel.org
In-Reply-To: <467fd703.72QYmCwQ6G3TPmF6%Joerg.Schilling@fokus.fraunhofer.de>
References: <467afc63.OnsqEXOk5zqMYzym%Joerg.Schilling@fokus.fraunhofer.de>
	 <1182469678.2704.16.camel@laptopd505.fenrus.org>
	 <467fd703.72QYmCwQ6G3TPmF6%Joerg.Schilling@fokus.fraunhofer.de>
Content-Type: text/plain
Organization: Intel International BV
Date: Mon, 25 Jun 2007 08:26:35 -0700
Message-Id: <1182785195.26621.9.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > I assume you typoed and meant "cleaned up kernel include files as
> > installed by make headers_install" instead.
> 
> I am thinking about kernel include files that do correct preincludes for
> type-cleanness and that work if you use them without #defining __KERNEL_

there is no __KERNEL__ in the "make headers_install"'d kernel headers.
And they are more or less sanity checked (no sanity check is complete
obviously) against certain common errors already (like including headers
that aren't installed).

if sanity checks are missing (and you seem to imply they do) then I'm
sure David welcomes suggestions for new sanity checks.
> > can you give a specific example of a header installed by make
> > headers_install that breaks this way and is hurting you? Because it may
> > well be possible to fix the problems, now that we have this special
> > cleanup phase since several releases....
> 
> star needs "ext2_fs.h". This file is not usable at all on many Linux 
> distributions, even with GCC.

oh I thought we were talking about the kernel, not about distributions.
Again, did you check the output of "make headers_install" (this is what
distributions are using going forward), and if so, can you give
*specific* examples of what we should add checks and fixes for?



-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

