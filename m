Return-Path: <linux-kernel-owner+w=401wt.eu-S1031116AbXECKQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031116AbXECKQk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 06:16:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031118AbXECKQk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 06:16:40 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:49478 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1031116AbXECKQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 06:16:39 -0400
Date: Thu, 3 May 2007 11:20:23 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Albert Cahalan <acahalan@gmail.com>,
       "Antonino A. Daplas" <adaplas@gmail.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, aeb@cwi.nl
Subject: Re: console font limits
Message-ID: <20070503112023.285f92c6@the-village.bc.nu>
In-Reply-To: <46398D1F.1020306@zytor.com>
References: <787b0d920704302109r352e6653wc71a0638cbfbdcce@mail.gmail.com>
	<Pine.LNX.4.64.0705011347300.27246@anakin>
	<1178021516.4372.62.camel@daplas>
	<46375738.1010007@zytor.com>
	<787b0d920705010849u52a4d6c3o2f1f800521ad5b95@mail.gmail.com>
	<46398D1F.1020306@zytor.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 03 May 2007 00:19:59 -0700
"H. Peter Anvin" <hpa@zytor.com> wrote:

> Albert Cahalan wrote:
> > Font size is not a sane place to draw the line. Features are.
> 
> Font sizes are an eminently sane place to draw the line, because the
> crossover is largely determined by the point at which nailing down too
> much memory (kernel memory = unswappable memory) gets too expensive.

Which is a value judgement made based upon the cost of memory, the
memory limit of the system (and the fixed kmalloc limits).

Obvious fix Albert would be to post patches which 

	-	Ignore the font size limits (up to sanity point) for 
		CAP_SYS_something
	-	Put the limit in sysfs where it belongs
	-	Use vmalloc not kmalloc if neccessary

Alan
